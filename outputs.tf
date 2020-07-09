output "contacts" {
  value = [for topic, contact in local.contacts : {
    topic       =  google_pubsub_topic.scc_topic[topic].id
    project_id  = contact.project_id
    team_prefix = contact.team_prefix
    email       = contact.email
  }]
}
