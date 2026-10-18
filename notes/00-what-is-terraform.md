# 00 — What is Terraform

Terraform is an Infrastructure as Code (IaC) tool. Instead of clicking through the AWS console to create a server, a bucket, or a database by hand, I describe what I want in a text file, and Terraform figures out what to actually create, change, or destroy on the real cloud to match it.

## Why this over clicking in a console

Manual console changes leave no record of *why* something exists, and they're not repeatable — if I need the same setup in a second environment, I have to remember and redo every click. A `.tf` file is checked into git like any other code: reviewable, repeatable, and it's the one place that says what the infrastructure is actually supposed to look like.

## The core building blocks

- **`terraform { required_providers { ... } }`** — which provider plugin to use (AWS, Azure, GCP, ...) and which version range is acceptable.
- **`provider "aws" { ... }`** — configures that provider, e.g. which region to operate in.
- **`resource "<type>" "<local_name>" { ... }`** — the actual thing to create. The type (e.g. `aws_s3_bucket`) comes from the provider; the local name is only used inside the Terraform project to refer to this resource elsewhere, AWS never sees it.

## The three-command workflow

- **`terraform init`** — downloads the provider plugin and writes `.terraform.lock.hcl`, which pins the exact version used so a later `init` doesn't silently pick up a newer, possibly different-behaving release.
- **`terraform plan`** — shows what *would* happen, without doing it. Diffs the `.tf` code (desired state) against `.tfstate` (last known real state) and prints exactly what would be added, changed, or destroyed.
- **`terraform apply`** — shows the same plan, then asks for an explicit `yes` before actually creating/changing/destroying anything for real.

## Three files, three very different jobs

| File | What it is | Goes in git? |
|---|---|---|
| `main.tf` | the code — what I want to exist | yes |
| `.terraform.lock.hcl` | the exact provider version Terraform locked in | yes |
| `terraform.tfstate` | Terraform's live record of what's actually been created on AWS | **no** |

`.tfstate` never goes in git — it changes on every `apply`, and it can hold sensitive values. On a real team, this file lives in a shared remote backend (commonly an S3 bucket plus a DynamoDB table for locking) instead of on one person's laptop, so everyone's Terraform is working from the same source of truth and two people can't corrupt it by applying at the same time. Covered in more depth once the exercises reach that point.

## `id` vs `arn`

Both only become known after a resource is created:

- **`id`** — Terraform's own internal handle for tracking a specific resource. Shape depends on the resource type.
- **`arn`** (Amazon Resource Name) — AWS's own global, standardized address for the resource, usable anywhere in AWS (most importantly, inside IAM policies that need to say "only this exact resource").
