output "contacts" {
  value = [for topic, contact in local.contacts : {
    topic       = topic
    project_id  = contact.project_id
    team_prefix = contact.team_prefix
    email       = contact.email
  }]
}

output "topics" {
  value =[]# [for k, v in google_pubsub_topic.scc_topic: v.id]
}
