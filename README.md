# terraform-practice

Hands-on Terraform (Infrastructure as Code) practice — real resources created and destroyed on AWS, not just reading syntax. Started 2026-10-18, same lesson-note format as [k8s-practice](https://github.com/NikanEidi/k8s-practice) and [langchain-practice](https://github.com/NikanEidi/langchain-practice): a `notes/` folder with one numbered Markdown file per lesson, code in its own per-exercise folder, real command output, mistakes documented, not just the clean final version.

Using a dedicated IAM user (`terraform-practice`, least-privilege, separate from my production IAM users) so this stays isolated from any real project's AWS resources while I'm still learning.

## Notes

- [`00-what-is-terraform.md`](notes/00-what-is-terraform.md) — what Terraform/IaC is, the core building blocks, the three-command workflow, `.tf` vs `.terraform.lock.hcl` vs `.tfstate`, `id` vs `arn`
- [`01-first-bucket.md`](notes/01-first-bucket.md) — one S3 bucket, created end-to-end ([`01-first-bucket/main.tf`](01-first-bucket/))
- [`02-variables-and-outputs.md`](notes/02-variables-and-outputs.md) — a `variable` for the bucket name, an `output` for its ARN, and a real gotcha: an output added after the resource already exists still needs its own `apply` to get computed into state ([`02-variables-and-outputs/`](02-variables-and-outputs/))
- [`03-iam-least-privilege.md`](notes/03-iam-least-privilege.md) — an IAM user + policy + attachment scoped to exactly one bucket, `jsonencode` for real IAM policy JSON, and a real `AccessDenied` wall (the practice IAM user needed its own scoped IAM permissions before it could create IAM resources) ([`03-iam-least-privilege/`](03-iam-least-privilege/))
- [`04-dynamodb-table.md`](notes/04-dynamodb-table.md) — a DynamoDB table (`PAY_PER_REQUEST` billing, schema-less beyond its key), and a real `EntityAlreadyExists` wall: IAM names are unique per AWS account, not per Terraform project, so copying exercise 03's IAM names into a new project collided with the real resources already created ([`04-dynamodb-table/`](04-dynamodb-table/))
- [`05-remote-state.md`](notes/05-remote-state.md) — moving state off my laptop into a shared S3 backend with native locking (`use_lockfile`, verified against the installed Terraform 1.16.6 before trusting it — no separate DynamoDB table needed since Terraform 1.10) ([`05-remote-state/`](05-remote-state/))
- [`06-module.md`](notes/06-module.md) — the same bucket+IAM pattern from exercises 03/04 as one reusable module instead of copy-pasted code, and a real mix-up between a module's own output and the root's output for that module ([`06-module/`](06-module/))

This closes the core exercise set (01–06).

**Note on cleanup:** exercises 01–04's resources have been `destroy`ed after being documented — nothing from them is still running on AWS. The `05-remote-state/bootstrap` bucket is intentionally kept, since `05-remote-state/app`'s state lives inside it.

## What comes after this repo

The next real step is applying Terraform to infrastructure that already exists: importing [Nik-Blog](https://github.com/NikanEidi/nik-blog)'s manually-created S3 bucket and IAM user under Terraform with `terraform import`, instead of destroying and recreating them — the realistic version of adopting IaC on an existing project.
