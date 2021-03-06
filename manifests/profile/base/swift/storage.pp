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
# == Class: tripleo::profile::base::swift::storage
#
# Swift storage profile for tripleo
#
# === Parameters
#
# [*step*]
#   (Optional) The current step in deployment. See tripleo-heat-templates
#   for more details.
#   Defaults to hiera('step')
#
# [*enable_swift_storage*]
#   (Optional) enable_swift_storage
#   Deprecated: defaults to true
#
class tripleo::profile::base::swift::storage (
  $step                 = hiera('step'),
  # Deprecated conditional to support ControllerEnableSwiftStorage parameter
  $enable_swift_storage = true,
) {

  if $step >= 4 {
    if $enable_swift_storage {
      include ::swift::storage::all
      if(!defined(File['/srv/node'])) {
        file { '/srv/node':
          ensure  => directory,
          owner   => 'swift',
          group   => 'swift',
          require => Package['openstack-swift'],
        }
      }
      $swift_components = ['account', 'container', 'object']
      swift::storage::filter::recon { $swift_components : }
      swift::storage::filter::healthcheck { $swift_components : }
    }
  }
}
