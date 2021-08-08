#################################
#          IAM ROLE             #
#################################
resource "aws_iam_role" "ssm_maintenance_window" {
  name = "${var.op_system}-${var.project}-${var.envname}-${var.vendor}-${var.osystem}-SSM-WIN-ROLE"
  path = "/system/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com","ssm.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "role_attach_ssm_mw" {
  role       = aws_iam_role.ssm_maintenance_window.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
}
#################################
#          Patch Baseline       #
#################################
# This patch_baseline will create 3 baselines that will approve CriticalUpdates and SecurityUpdates with 7,15 and 30 after published in  Microsoft Update Catalog. 
#
resource "aws_ssm_patch_baseline" "baseline7D" {
  name             = "${var.project}-${var.envname}-${var.vendor}-${var.osystem}-7D-Patch-Baseline"
  description      = "This Patch Baseline will auto  approve CriticalUpdates and SecurityUpdates after 7D days after published in  Microsoft Update Catalog."
  operating_system = var.op_system
  #approved_patches = var.approved_patches
  #rejected_patches = var.rejected_patches

  approval_rule {
    approve_after_days = 7

    patch_filter {
      key    = "PRODUCT"
      values = var.product_versions
    }

    patch_filter {
      key    = "CLASSIFICATION"
      values = var.patch_classification
    }

    patch_filter {
      key    = "MSRC_SEVERITY"
      values = var.patch_severity
    }
  }
  tags = {
    SSM-project = var.project
    SSM-Envname = var.envname
    SSM-Vendor  = var.vendor
    SSM-OSystem = var.osystem
  }
}


resource "aws_ssm_patch_baseline" "baseline15D" {
  name             = "${var.project}-${var.envname}-${var.vendor}-${var.osystem}-15D-Patch-Baseline"
  description      = "This Patch baseline will auto  approve CriticalUpdates and SecurityUpdates after 15D days after published in  Microsoft Update Catalog."
  operating_system = var.op_system
  #approved_patches = var.approved_patches
  #rejected_patches = var.rejected_patches

  approval_rule {
    approve_after_days = 15

    patch_filter {
      key    = "PRODUCT"
      values = var.product_versions
    }

    patch_filter {
      key    = "CLASSIFICATION"
      values = var.patch_classification
    }

    patch_filter {
      key    = "MSRC_SEVERITY"
      values = var.patch_severity
    }
  }
  tags = {
    SSM-project = var.project
    SSM-Envname = var.envname
    SSM-Vendor  = var.vendor
    SSM-OSystem = var.osystem
  }
}

resource "aws_ssm_patch_baseline" "baseline30D" {
  name             = "${var.project}-${var.envname}-${var.vendor}-${var.osystem}-30D-Patch-Baseline"
  description      = "This PatchBbaseline will auto  approve CriticalUpdates and SecurityUpdates after 30D days after published in  Microsoft Update Catalog."
  operating_system = var.op_system
  #approved_patches = var.approved_patches
  #rejected_patches = var.rejected_patches

  approval_rule {
    approve_after_days = 30

    patch_filter {
      key    = "PRODUCT"
      values = var.product_versions
    }

    patch_filter {
      key    = "CLASSIFICATION"
      values = var.patch_classification
    }

    patch_filter {
      key    = "MSRC_SEVERITY"
      values = var.patch_severity
    }
  }
  tags = {
    SSM-project = var.project
    SSM-Envname = var.envname
    SSM-Vendor  = var.vendor
    SSM-OSystem = var.osystem
  }
}

#################################
#          Patch Groups         #
#################################
#
# This will create 6 patch groups, every two of them will use one patch base line and will run in two different windows.
#
#
resource "aws_ssm_patch_group" "pg7days-pg1" {
  baseline_id = aws_ssm_patch_baseline.baseline7D.id
  patch_group = "${var.vendor}-${var.osystem}-CU7D-PG1"
}
resource "aws_ssm_patch_group" "pg7days-pg2" {
  baseline_id = aws_ssm_patch_baseline.baseline7D.id
  patch_group = "${var.vendor}-${var.osystem}-CU7D-PG2"
}

resource "aws_ssm_patch_group" "pg15days-pg1" {
  baseline_id = aws_ssm_patch_baseline.baseline15D.id
  patch_group = "${var.vendor}-${var.osystem}-CU15D-PG1"
}

resource "aws_ssm_patch_group" "pg15days-pg2" {
  baseline_id = aws_ssm_patch_baseline.baseline15D.id
  patch_group = "${var.vendor}-${var.osystem}-CU15D-PG2"
}

resource "aws_ssm_patch_group" "pg30days-pg1" {
  baseline_id = aws_ssm_patch_baseline.baseline30D.id
  patch_group = "${var.vendor}-${var.osystem}-CU30D-PG1"
}

resource "aws_ssm_patch_group" "pg30days-pg2" {
  baseline_id = aws_ssm_patch_baseline.baseline30D.id
  patch_group = "${var.vendor}-${var.osystem}-CU30D-PG2"
}
#################################
#        Mainenance Windows     #
#################################
# This will create 6 maintenance windows, each one will run one time and will have one  aws_ssm_patch_group.


## 7 DAYS UPDATES
resource "aws_ssm_maintenance_window" "mt7days-mt1" {
  name     = "${var.project}-${var.envname}-${var.vendor}-${var.osystem}-MT-WEDNESDAY-2AM-CU7D"
  schedule = var.install_maintenance_window_schedule_1
  duration = 4
  cutoff   = 1
  tags = {
    SSM-project    = var.project
    SSM-Envname    = var.envname
    SSM-Vendor     = var.vendor
    SSM-OSystem    = var.osystem
    SSM-PatchGroup = "${aws_ssm_patch_group.pg7days-pg1.id}"
  }
}

resource "aws_ssm_maintenance_window" "mt7days-mt2" {
  name     = "${var.project}-${var.envname}-${var.vendor}-${var.osystem}-MT-SATURDAY-2AM-CU7D"
  schedule = var.install_maintenance_window_schedule_2
  duration = 4
  cutoff   = 1
  tags = {
    SSM-project    = var.project
    SSM-Envname    = var.envname
    SSM-Vendor     = var.vendor
    SSM-OSystem    = var.osystem
    SSM-PatchGroup = "${aws_ssm_patch_group.pg7days-pg2.id}"
  }
}

## 15 DAYS UPDATES
resource "aws_ssm_maintenance_window" "mt15days-mt1" {
  name     = "${var.project}-${var.envname}-${var.vendor}-${var.osystem}-MT-WEDNESDAY-2AM-CU15D"
  schedule = var.install_maintenance_window_schedule_1
  duration = 4
  cutoff   = 1
  tags = {
    SSM-project    = var.project
    SSM-Envname    = var.envname
    SSM-Vendor     = var.vendor
    SSM-OSystem    = var.osystem
    SSM-PatchGroup = "${aws_ssm_patch_group.pg15days-pg1.id}"
  }
}

resource "aws_ssm_maintenance_window" "mt15days-mt2" {
  name     = "${var.project}-${var.envname}-${var.vendor}-${var.osystem}-MT-SATURDAY-2AM-CU15D"
  schedule = var.install_maintenance_window_schedule_2
  duration = 4
  cutoff   = 1
  tags = {
    SSM-project    = var.project
    SSM-Envname    = var.envname
    SSM-Vendor     = var.vendor
    SSM-OSystem    = var.osystem
    SSM-PatchGroup = "${aws_ssm_patch_group.pg15days-pg2.id}"
  }
}


## 30 DAYS UPDATES
resource "aws_ssm_maintenance_window" "mt30days-mt1" {
  name     = "${var.project}-${var.envname}-${var.vendor}-${var.osystem}-MT-WEDNESDAY-2AM-CU30D"
  schedule = var.install_maintenance_window_schedule_1
  duration = 4
  cutoff   = 1
  tags = {
    SSM-project    = var.project
    SSM-Envname    = var.envname
    SSM-Vendor     = var.vendor
    SSM-OSystem    = var.osystem
    SSM-PatchGroup = "${aws_ssm_patch_group.pg30days-pg1.id}"
  }
}

resource "aws_ssm_maintenance_window" "mt30days-mt2" {
  name     = "${var.project}-${var.envname}-${var.vendor}-${var.osystem}-MT-SATURDAY-2AM-CU30D"
  schedule = var.install_maintenance_window_schedule_2
  duration = 4
  cutoff   = 1
  tags = {
    SSM-project    = var.project
    SSM-Envname    = var.envname
    SSM-Vendor     = var.vendor
    SSM-OSystem    = var.osystem
    SSM-PatchGroup = "${aws_ssm_patch_group.pg30days-pg2.id}"
  }
}

#################################
#        Window Target          #
#################################
# This will create 6  window target, each one will have one aws_ssm_patch_group.
#
# 7 DAYS UPDATES
resource "aws_ssm_maintenance_window_target" "tg7days-tg1" {
  window_id     = aws_ssm_maintenance_window.mt7days-mt1.id
  name          = "EC2-TAGGED-AS-${aws_ssm_patch_group.pg7days-pg1.id}"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Patch Group"
    values = ["${aws_ssm_patch_group.pg7days-pg1.id}"]
  }
}

resource "aws_ssm_maintenance_window_target" "tg7days-tg2" {
  window_id     = aws_ssm_maintenance_window.mt7days-mt2.id
  name          = "EC2-TAGGED-AS-${aws_ssm_patch_group.pg7days-pg2.id}"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Patch Group"
    values = ["${aws_ssm_patch_group.pg7days-pg2.id}"]
  }
}

# 15 DAYS UPDATES
resource "aws_ssm_maintenance_window_target" "tg15days-tg1" {
  window_id     = aws_ssm_maintenance_window.mt15days-mt1.id
  name          = "EC2-TAGGED-AS-${aws_ssm_patch_group.pg15days-pg1.id}"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Patch Group"
    values = ["${aws_ssm_patch_group.pg15days-pg1.id}"]
  }
}

resource "aws_ssm_maintenance_window_target" "tg15days-tg2" {
  window_id     = aws_ssm_maintenance_window.mt15days-mt2.id
  name          = "EC2-TAGGED-AS-${aws_ssm_patch_group.pg15days-pg2.id}"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Patch Group"
    values = ["${aws_ssm_patch_group.pg15days-pg2.id}"]
  }
}

# 30 DAYS UPDATES
resource "aws_ssm_maintenance_window_target" "tg30days-tg1" {
  window_id     = aws_ssm_maintenance_window.mt30days-mt1.id
  name          = "EC2-TAGGED-AS-${aws_ssm_patch_group.pg30days-pg1.id}"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Patch Group"
    values = ["${aws_ssm_patch_group.pg30days-pg1.id}"]
  }
}

resource "aws_ssm_maintenance_window_target" "tg30days-tg2" {
  window_id     = aws_ssm_maintenance_window.mt30days-mt2.id
  name          = "EC2-TAGGED-AS-${aws_ssm_patch_group.pg30days-pg2.id}"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Patch Group"
    values = ["${aws_ssm_patch_group.pg30days-pg2.id}"]
  }
}

#################################
#        Window TASK            #
#################################
#7 Days
resource "aws_ssm_maintenance_window_task" "task_install_patches1" {
  window_id        = aws_ssm_maintenance_window.mt7days-mt1.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-ApplyPatchBaseline"
  priority         = 1
  service_role_arn = aws_iam_role.ssm_maintenance_window.arn
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors

  targets {
    key    = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window_target.tg7days-tg1.id}"]
  }

  task_parameters {
    name   = "Operation"
    values = ["Install"]
  }
}

resource "aws_ssm_maintenance_window_task" "task_install_patches2" {
  window_id        = aws_ssm_maintenance_window.mt7days-mt2.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-ApplyPatchBaseline"
  priority         = 1
  service_role_arn = aws_iam_role.ssm_maintenance_window.arn
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors

  targets {
    key    = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window_target.tg7days-tg2.id}"]
  }

  task_parameters {
    name   = "Operation"
    values = ["Install"]
  }
}

## 15 Days
resource "aws_ssm_maintenance_window_task" "task_install_patches3" {
  window_id        = aws_ssm_maintenance_window.mt15days-mt1.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-ApplyPatchBaseline"
  priority         = 1
  service_role_arn = aws_iam_role.ssm_maintenance_window.arn
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors

  targets {
    key    = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window_target.tg15days-tg1.id}"]
  }

  task_parameters {
    name   = "Operation"
    values = ["Install"]
  }
}

resource "aws_ssm_maintenance_window_task" "task_install_patches4" {
  window_id        = aws_ssm_maintenance_window.mt15days-mt2.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-ApplyPatchBaseline"
  priority         = 1
  service_role_arn = aws_iam_role.ssm_maintenance_window.arn
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors

  targets {
    key    = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window_target.tg15days-tg2.id}"]
  }

  task_parameters {
    name   = "Operation"
    values = ["Install"]
  }
}

## 30 Days
resource "aws_ssm_maintenance_window_task" "task_install_patches5" {
  window_id        = aws_ssm_maintenance_window.mt30days-mt1.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-ApplyPatchBaseline"
  priority         = 1
  service_role_arn = aws_iam_role.ssm_maintenance_window.arn
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors

  targets {
    key    = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window_target.tg30days-tg1.id}"]
  }

  task_parameters {
    name   = "Operation"
    values = ["Install"]
  }
}

resource "aws_ssm_maintenance_window_task" "task_install_patches6" {
  window_id        = aws_ssm_maintenance_window.mt30days-mt2.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-ApplyPatchBaseline"
  priority         = 1
  service_role_arn = aws_iam_role.ssm_maintenance_window.arn
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors

  targets {
    key    = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window_target.tg30days-tg2.id}"]
  }

  task_parameters {
    name   = "Operation"
    values = ["Install"]
  }
}