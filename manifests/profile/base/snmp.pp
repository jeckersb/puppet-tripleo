# Copyright 2016 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: tripleo::profile::base::snmp
#
# SNMP profile for tripleo
#
# === Parameters
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
# [*snmpd_user*]
#   The SNMP username
#   Defaults to hiera('snmpd_readonly_user_name')
#
# [*snmpd_password*]
#   The SNMP password
#   Defaults to hiera('snmpd_readonly_user_password')
#
class tripleo::profile::base::snmp (
  $step           = hiera('step'),
  $snmpd_user     = hiera('snmpd_readonly_user_name'),
  $snmpd_password = hiera('snmpd_readonly_user_password'),
) {

  if $step >= 4 {
    snmp::snmpv3_user { $snmpd_user:
      authtype => 'MD5',
      authpass => $snmpd_password,
    }
    class { '::snmp':
      agentaddress => ['udp:161','udp6:[::1]:161'],
      snmpd_config => [ join(['createUser ', $snmpd_user, ' MD5 "', $snmpd_password, '"']), join(['rouser ', $snmpd_user]), 'proc  cron', 'includeAllDisks  10%', 'master agentx', 'trapsink localhost public', 'iquerySecName internalUser', 'rouser internalUser', 'defaultMonitors yes', 'linkUpDownNotifications yes' ],
    }
  }
}
