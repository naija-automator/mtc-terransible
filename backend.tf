terraform {
  backend "remote" {
    organization = "phunkytech-mtc-terransible"

    workspaces {
      name = "terransible"
    }
  }
}
