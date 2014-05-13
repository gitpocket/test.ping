test.ping
=========

This repository is used to document our testing procedures, and provide some resources for testing and standards across our roles.

## Testing Environment

Testing is performed using [Drone](https://github.com/drone/drone). In order for tests to be run for your repository, the following steps have to be followed.

1. Add the role to [Ansible Galaxy](https://galaxy.ansible.com/) under our [Rackspace_Automation](https://galaxy.ansible.com/list#/users/2126) user.
1. Add the repository to our [drone instance](https://drone-opsdev.rax.io/dashboard).
1. Create a `.drone.yml` file in the root of your repository. Follow [this example](https://github.com/rack-roles/test.ping/blob/master/.drone.yml.example).
1. Create a `tests` directory in the root of your repository. Follow [this example](https://github.com/rack-roles/test.ping/tree/master/tests).
* `roles.list` contains a list of roles to be installed before invoking your test playbook. **Should include the role you are testing at a minimum.**
* `main.yml` is the playbook that performs the functional test of your role. [This example](https://github.com/rack-roles/test.ping/blob/master/tests/main.yml) shows a minimum requirements.
