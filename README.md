# SCC Multiplexer

This very simple terraform module allows your team to manage Google Security Command Center notifications
such that each team's findings are sent to their own pubsub topic based on the project id. All pubsub
topics are created along with the notification configuration, which is currently alpha, so we need to use
a `null_resource` to shell out to `gcloud` until this feature is added to the the terraform-google-provider.


## Usage

Copy `terraform.tfvars.sample` to `terraform.tfvars` and update with your values.

Then simply run `terraform apply`

You can ensure the notifications are correct by running:

```
gcloud alpha scc notifications list $ORG_ID
```
If you want the full list of contacts including interpolated values as json you can run this in scripts:

```
$ terraform output -json contacts | jq .
[
  {
    "project_id": "dataflow-project",
    "team_prefix": "data",
    "topic": "projects/pubsub-project/topics/scc-data-dataflow-project",
    "email": "data@example.com"
  },
  {
    "project_id": "security-project",
    "team_prefix": "seceng",
    "topic": "projects/pubsub-project/topics/scc-seceng-security-project",
    "email": "security@example.com"
  }
]

```
