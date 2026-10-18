# terraform-practice

Hands-on Terraform (Infrastructure as Code) practice — real resources created and destroyed on AWS, not just reading syntax. Started 2026-10-18, same lesson-note format as [k8s-practice](https://github.com/NikanEidi/k8s-practice) and [langchain-practice](https://github.com/NikanEidi/langchain-practice): a `notes/` folder with one numbered Markdown file per lesson, code in its own per-exercise folder, real command output, mistakes documented, not just the clean final version.

Using a dedicated IAM user (`terraform-practice`, least-privilege, separate from my production IAM users) so this stays isolated from any real project's AWS resources while I'm still learning.

## Notes

- [`00-what-is-terraform.md`](notes/00-what-is-terraform.md) — what Terraform/IaC is, the core building blocks, the three-command workflow, `.tf` vs `.terraform.lock.hcl` vs `.tfstate`, `id` vs `arn`
- [`01-first-bucket.md`](notes/01-first-bucket.md) — one S3 bucket, created end-to-end ([`01-first-bucket/main.tf`](01-first-bucket/))

More notes (variables/outputs, a least-privilege IAM role scoped to one bucket, a second resource type, remote state with locking, combining everything into one module) land here as exercises are completed.

## What comes after this repo

Once the core exercises are done, the next real step is applying Terraform to infrastructure that already exists: importing [Nik-Blog](https://github.com/NikanEidi/nik-blog)'s manually-created S3 bucket and IAM user under Terraform with `terraform import`, instead of destroying and recreating them — the realistic version of adopting IaC on an existing project.
