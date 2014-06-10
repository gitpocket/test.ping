test.ping
=========

This repository is used to document our testing procedures, and provide some resources for testing and standards across our roles.

## Parameters

**If your role requires any sort of credentials, mark the repository as PRIVATE in Drone. This will prevent credentials from leaking in the debug output.**

Here is a good convention for defining these via ENV variables. This doesn't prevent leakage of data through a failed task in your tasks.

```
image: linuturk/ubuntu-ansible
env:
  - RAXUSER={{rax_user}}
  - RAXKEY={{rax_key}}
script:
  - ansible-galaxy install -r $DRONE_BUILD_DIR/tests/roles.list
  - ansible-playbook --syntax-check $DRONE_BUILD_DIR/tests/main.yml
  - ansible-playbook $DRONE_BUILD_DIR/tests/main.yml --extra-vars "rackspace_username=$RAXUSER rackspace_apikey=$RAXKEY"
  - ansible-playbook $DRONE_BUILD_DIR/tests/main.yml --extra-vars "rackspace_username=$RAXUSER rackspace_apikey=$RAXKEY"
  - "ansible-playbook $DRONE_BUILD_DIR/tests/main.yml --extra-vars \"rackspace_username=$RAXUSER rackspace_apikey=$RAXKEY\" | grep -q 'changed=0.*failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)"
```

## Testing Environment

Testing is performed using [Drone](https://github.com/drone/drone).

* Sytax checking is performed with the `ansible-playbook --syntax-check` option.
* Function tests are run using the `main.yml` playbook in the `tests` directory.

In order for tests to be run for your repository, the following steps have to be followed:

1. Add the role to [Ansible Galaxy](https://galaxy.ansible.com/) under our [Rackspace_Automation](https://galaxy.ansible.com/list#/users/2126) user.
1. Add the repository to our [drone instance](https://drone-opsdev.rax.io/dashboard/team/opsdev-ansible). **Mark the repository as PRIVATE in Drone.**
1. If your templates directory **doesn't** have any templates, touch a file named `placeholder.j2` in that directory. This is required for the syntax checking above.
1. Create a `.drone.yml` file in the root of your repository. [This file](https://github.com/rack-roles/test.ping/blob/master/.drone.yml.example) should drop in without any modification.
1. Create a `tests` directory in the root of your repository. Follow [this example](https://github.com/rack-roles/test.ping/tree/master/tests).
* `roles.list` contains a list of roles to be installed before invoking your test playbook. **Should include the role you are testing at a minimum.**
* `main.yml` is the playbook that performs the functional test of your role. [This example](https://github.com/rack-roles/test.ping/blob/master/tests/main.yml) shows a minimum requirements. **Add any functional tests using the various testing modules in Ansible (assert, stat, uri, etc)**

## Docker Images

There are currently two docker images available for testing:

* `linuturk/ubuntu-ansible` is based on Ubuntu 14.04 and is built from [this source.](https://github.com/Linuturk/ubuntu-ansible)
* `linuturk/centos-ansible` is based on CentOS 6.5 and is built from [this source.](https://github.com/Linuturk/centos-ansible)

You can specifiy either of these images in your testing, and you won't have to worry about installing Ansible in your Docker image.

## Docker Testing Gotchas

### Rsyslog

A good number of services and packages require some sort of system logging to be running inside the container. Docker images typically don't start any such service. If you are seeing strange behavior, it might be worth it to add the following line to your `.drone.yml` file.

```
rsyslogd &
```

## Conventions

This section is for common conventions we should be following when creating our roles.

### OS Support

* We are currently targeting **Ubuntu 14.04 LTS** with these roles.
* Multi-distribution targeting should be done in a manner similar to the [newrelic role](https://github.com/rack-roles/newrelic/tree/master/tasks). Avoid multiple `when: ansible_os_family` calls and split tasks once in the `main.yml` task file. 

main.yml
```
- include: debian.yml
  when: ansible_os_family == 'Debian'
  
- include: redhat.yml
  when: ansible_os_family == 'RedHat'
  
- include: unsupported_os.yml
  when: YOURROLE_supported_os is not defined
```

debian.yml
```
---
- name: Debian | Supported OS
  set_fact:
    YOURROLE_supported_os: True
    
# Rest of your included tasks here
```

unsupported_os.yml
```
---
- name: Default | Check for unsupported target operating system
  fail:
    msg: "The operating system of the target machine ({{ inventory_hostname }}) is not currently supported"

```

### Ansible Managed Message

Include the [Ansible Managed message](https://github.com/rack-roles/test.ping/blob/master/managed.j2) at the top of any templates.

```
################################################################################
# {{ ansible_managed }}
# Contact your support team for assistance with this file.
################################################################################
```

### Galaxy Meta Files

Changes to the `meta/main.yml` file will not automatically reload in Galaxy. The change has to be imported manually through the Ansible Galaxy website.

### Variables

#### README File

When describing variables in a README file, the following format seems to be the easiest to read.

* `variable_name`: Description of the variable. (Default: default_value)

#### Namespacing

All variables should include the role name so they are properly namespaced to avoid conflicts. `role_name_variable_name` is a good example.

Some variables will be able to span across roles. Use the following variables if you have need of their values:

* `rackspace_username`: The Rackspace Cloud Account username.
* `rackspace_apikey`: The Rackspace Cloud Account api key.

#### Mandatory Variables

Start your tasks with a check on mandatory variables that can't be defined in defaults. A good example of this would be credentials, like a newrelic key or rackspace cloud username / apikey.

```
- name: Check for newrelic_license_key
  fail:
    msg: "newrelic_license_key has not been defined"
  when: newrelic_license_key|default(False) == False
```

#### Testing with Variables

Drone has the ability to embed provided variables into your `.drone.yml`. Add a variable to drone in the Params section and you can then reference the variables in your `.drone.yml` file, jinja style. See the [drone docs](https://github.com/drone/drone#params-injection) for an example.

#### List Unisons

List unisons are useful when you need to combine a set of default values with a list of supplied options, without having to redefine the entire default list. Here is a good example showing the installation of packages:

```
vars:
  default_packages:
    - vim
    - strace
  custom_packages:
    - cowsay
tasks:
  - name: installing a bunch o packages
    apt: pkg={{ item }} state=present
    with_items: default_packages| union(custom_packages)
    when: ansible_os_family == 'Debian'
```

### Conditional Tasks with Register and When

Sometimes, whether or not a task should be run depends on the result of another task. You can make use of the `register` and `when` modules to build in this logic.

Here we are only rebuilding kibana IF git detects a change or if we are manually forcing it by overriding the `kibana_force_rebuild` variable which defaults to False.

```
- name: Clone Kibana
  git: repo={{ kibana_git }} dest={{ kibana_git_clone_location }} update=yes version={{ kibana_git_branch_or_tag }}
  register: git_clone_result

- name: Rebuild Kibana
  include: rebuild_kibana.yml
  when: git_clone_result|changed or kibana_force_rebuild
```
