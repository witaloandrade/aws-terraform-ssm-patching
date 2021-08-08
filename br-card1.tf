module "windows-patching-us-east-1" {
  source = "./modules/ssm-patch-mgmt-win"
  ## General Vars
  project = "CARD"
  envname = "PROD"
  vendor  = "MS"
  osystem = "WINDOWS"
  ## Patch Baseline Vars
  providers = {
    aws = aws.us-east-1
  }

}
