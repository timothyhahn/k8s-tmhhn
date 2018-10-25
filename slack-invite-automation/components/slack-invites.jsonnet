local env = std.extVar("__ksonnet/environments");
local params = std.extVar("__ksonnet/params").components["slack-invites"];
[
   {
      "apiVersion": "extensions/v1beta1",
      "kind": "Ingress",
      "metadata": {
         "name": params.name
      },
      "spec": {
        "rules": [
            {
                "http": {
                    "paths": [
                        {
                            "backend": {
                                "serviceName": params.name,
                                "servicePort": params.servicePort
                            }
                        }
                    ]
                }
            }
        ]
      },
   },
   {
      "apiVersion": "v1",
      "kind": "Service",
      "metadata": {
         "name": params.name
      },
      "spec": {
         "ports": [
            {
               "port": params.servicePort,
               "targetPort": params.containerPort
            }
         ],
         "selector": {
            "app": params.name
         },
         "type": params.type
      }
   },
   {
      "apiVersion": "apps/v1beta2",
      "kind": "Deployment",
      "metadata": {
         "name": params.name
      },
      "spec": {
         "replicas": params.replicas,
         "selector": {
            "matchLabels": {
               "app": params.name
            },
         },
         "template": {
            "metadata": {
               "labels": {
                  "app": params.name
               }
            },
            "spec": {
               "containers": [
                  {
                     "image": params.image,
                     "name": params.name,
                     "ports": [
                         {
                            "containerPort": params.containerPort
                         },
                     ],
                     "env": [
                        {
                            name: 'COMMUNITY_NAME',
                            value: 'Curalumni'
                        },
                        {
                            name: 'SLACK_URL',
                            value: 'curalumni.slack.com'
                        },
                        {
                            name: 'SLACK_TOKEN',
                            valueFrom: {
                                secretKeyRef: {
                                    name: 'curalumni-slack-secrets',
                                    key: 'slack-token'
                                }
                            }
                        },
                        {
                            name: 'INVITE_TOKEN',
                            valueFrom: {
                                secretKeyRef: {
                                    name: 'curalumni-slack-secrets',
                                    key: 'invite-token'
                                }
                            }
                        },
                        {
                            name: 'LOCALE',
                            value: 'en'
                        }
                     ]
                  }
               ]
            }
         }
      }
   }
]
