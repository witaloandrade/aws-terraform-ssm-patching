module "ssm-patching" {
  source = "../modules/ssm-patch-mgmt-lin"
  ## General Vars
  project = var.project
  envname = var.envname
  vendor  = var.vendor
  osystem = var.osystem
  ## Patch Baseline Vars
  op_system = var.op_system
}