{
  global: {
    // User-defined global parameters; accessible to all component and environments, Ex:
    // replicas: 4,
  },
  components: {
    // Component-level parameters, defined initially from 'ks prototype use ...'
    // Each object below should correspond to a component in the components/ directory
    "slack-invites": {
      containerPort: 80,
      image: "outsideris/slack-invite-automation",
      name: "slack-invites",
      replicas: 1,
      servicePort: 80,
      type: "LoadBalancer",
    },
  },
}
