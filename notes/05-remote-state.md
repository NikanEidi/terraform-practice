# 05 — Remote state with locking

Up to now, every exercise's `terraform.tfstate` lived on my own laptop. That's fine solo, but breaks the moment a second person (or a second me, on a different machine) runs Terraform against the same real infrastructure — two separate local state files, neither aware of the other, can easily collide or destroy something the other one created. This exercise moves state off my laptop into a shared S3 backend, with locking so two applies can't corrupt it by running at the same time.

## The chicken-and-egg problem

The bucket that stores state can't itself be created using that same remote state — it doesn't exist yet. Solved with two separate projects:

- [`bootstrap/`](../05-remote-state/bootstrap/) — creates the state bucket, using ordinary local state (no backend block, same as every exercise before this one).
- [`app/`](../05-remote-state/app/) — a normal project (one S3 bucket), except its state lives in the bucket `bootstrap/` just created.

## `bootstrap/main.tf` — the permanent piece

```hcl
resource "aws_s3_bucket" "tf_state" {
  bucket = "nikan-terraform-practice-state-2026"
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
```

Unlike every other bucket in this repo, this one isn't meant to be destroyed when the exercise is done — `app/`'s backend points at it, so deleting it would mean Terraform loses its only record of what `app/` actually created on AWS. Versioning is turned on deliberately: if the state file ever gets overwritten or corrupted, the previous version is still recoverable.

## `app/main.tf` — pointing state at that bucket

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "nikan-terraform-practice-state-2026"
    key          = "05-remote-state/app/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
```

`key` is just the path inside the bucket where this project's state object lives — lets one bucket hold state for many different projects, each at its own key.

## A real correction, caught before building the wrong thing

Was about to build the classic pattern — a second DynamoDB table just for locking, alongside `dynamodb_table = "..."` in the backend block. Before teaching it, actually ran `terraform init` against this exact installed version (1.16.6) with `use_lockfile = true` instead, and it was accepted and understood by the backend — confirming that since Terraform 1.10, the S3 backend can lock natively, with no separate DynamoDB table required. The older DynamoDB-based pattern still works and is still common in existing codebases (worth knowing it exists and why), but it's no longer the current default, and I'd been about to teach it as current without checking.

## Verified: state is actually remote now

```bash
$ terraform init
Successfully configured the backend "s3"!

$ terraform apply
aws_s3_bucket.practice_bucket: Creation complete after 1s [id=nikan-terraform-practice-05]
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
bucket_arn = "arn:aws:s3:::nikan-terraform-practice-05"

$ ls
.terraform  .terraform.lock.hcl  main.tf
```

No `terraform.tfstate` anywhere in the local folder — the first time that's been true in this whole repo. Confirmed it's really in the bucket:

```bash
$ aws s3 ls s3://nikan-terraform-practice-state-2026/05-remote-state/app/
2026-10-18 17:33:49       2829 terraform.tfstate
```

## What the locking actually does (not directly re-tested here, but worth stating precisely)

`use_lockfile = true` makes Terraform write a small lock object next to the state file in S3 for the duration of any operation that would change it (`apply`, `destroy`). If a second `apply` starts while that lock exists, it fails immediately instead of writing state at the same time as the first one — the exact scenario this exercise exists to prevent. The older DynamoDB-table pattern does the same job through a different mechanism (a lock row in a DynamoDB table instead of a lock object in S3).
