## General vars
variable "op_system" {
  description = "Defines the operating system the patch baseline applies to."
  type        = string
  default     = "AMAZON_LINUX_2"
}

variable "project" {
  description = "This name will prefix all resources, and be added as the value for the 'SSM-Project' tag where supported"
  type        = string
  default     = "BR-CARD1"
}

variable "envname" {
  description = "This name will prefix all resources, and be added as the value for the 'SSM-Envname' tag where supported"
  type        = string
  default     = "DEV"
}

variable "vendor" {
  description = "This name will prefix all resources, and be added as the value for the 'SSM-Vendor' tag where supported"
  type        = string
  default     = "LX"
}

variable "osystem" {
  description = "This name will prefix all resources, and be added as the value for the 'SSM-osystem' tag where supported"
  type        = string
  default     = "LIN"
}

#variable "product_versions" {
#  description = "The list of product versions for the SSM baseline"
#  type        = list(string)
#  default     = ["WindowsServer2016", "WindowsServer2012R2"]
#}

#variable "patch_classification" {
#  description = "The list of patch classifications for the SSM baseline"
#  type        = list(string)
#  default     = ["CriticalUpdates", "SecurityUpdates"]
#}

#variable "patch_severity" {
#  description = "The list of patch severities for the SSM baseline"
#  type        = list(string)
#  default     = ["Critical", "Important"]
#}
### Maintenance Window Schedule
#variable "install_maintenance_window_schedule_1" {
#  description = "The  Firts schedule of the install Maintenance Window in the form of a cron or rate expression"
#  type        = string
#  default     = "cron(00 02 ? * WED *)"
#}
#
#variable "install_maintenance_window_schedule_2" {
#  description = "The Second schedule of the install Maintenance Window in the form of a cron or rate expression"
#  type        = string
#  default     = "cron(00 02 ? * SAT *)"
#}
#
#variable "max_concurrency" {
#  description = "The maximum amount of concurrent instances of a task that will be executed in parallel"
#  type        = string
#  default     = "20%"
#}
#
#variable "max_errors" {
#  description = "The maximum amount of errors that instances of a task will tollerate before being de-scheduled"
#  type        = string
#  default     = "30%"
#}