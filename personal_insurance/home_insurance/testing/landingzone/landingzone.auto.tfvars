config = {

  management_group = {
    level0 = {
      id               = "myorg"
      display_name     = "My Organization"
      subscription_ids = []
      level1           = [
        {
          id               = "myorg-decommissioned"
          display_name     = "Decommissioned"
          subscription_ids = []
          level2           = []
        },
        {
          id               = "myorg-landing_zones"
          display_name     = "Landing Zones"
          subscription_ids = []
          level2           = []
        },
        {
          id               = "myorg-platform"
          display_name     = "Platform"
          subscription_ids = []
          level2           = [
            {
              id               = "myorg-connectivity"
              display_name     = "Connectivity"
              subscription_ids = []
            },
            {
              id               = "myorg-management"
              display_name     = "Management"
              subscription_ids = []
            },
            {
              id               = "myorg-identity"
              display_name     = "Identity"
              subscription_ids = []
            },
          ]
        },
        {
          id               = "myorg-sandboxes"
          display_name     = "Sandboxes"
          subscription_ids = []
          level2          = []
        },
      ]
    }
  }
}
