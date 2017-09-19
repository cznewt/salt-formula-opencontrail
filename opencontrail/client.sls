{%- from "opencontrail/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

opencontrail_client_packages:
  pkg.installed:
  - names: {{ client.pkgs }}

{%- if not pillar.opencontrail.config is defined %}
{%- if client.identity.engine == "keystone" %}
/etc/contrail/vnc_api_lib.ini:
  file.managed:
  - source: salt://opencontrail/files/{{ client.version }}/client_vnc_api_lib.ini
  - template: jinja
  - require:
    - pkg: opencontrail_client_packages
{%- endif %}
{%- endif %}

{%- for virtual_router_name, virtual_router in client.get('virtual_router', {}).items() %}

opencontrail_client_virtual_router_{{ virtual_router_name }}:
  contrail.virtual_router_present:
  - name: {{ virtual_router.get('name', virtual_router_name) }}
  - router_type: {{ virtual_router.get('router_type', virtual_router_name)}}
  - ip_address: {{ virtual_router.ip_address }}
  - dpdk_enabled: {{ virtual_router.get('dpdk_enabled', False) }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'

{%- endfor %}

{%- if pillar.opencontrail.get('compute',{}).get('tor', {}).get('enabled', False) %}

{%- for tor_name, tor in pillar.opencontrail.compute.tor.get('agent', {}).items() %}

opencontrail_client_tor_router_{{ tor_name }}:
  contrail.virtual_router_present:
  - name: {{ pillar.linux.system.name }}-{{ tor.id }}
  - router_type: tor-agent
  - ip_address: {{ tor.address }}

{%- endfor %}

{%- endif %}


{%- for config_node_name, config_node in client.get('config_node', {}).items() %}

opencontrail_client_config_node_{{ config_node_name }}:
  contrail.config_node_present:
  - name: {{ config_node.get('name', config_node_name) }}
  - ip_address: {{ config_node.ip_address }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'

{%- endfor %}

{%- for bgp_router_name, bgp_router in client.get('bgp_router', {}).items() %}

opencontrail_client_bgp_router_{{ bgp_router_name }}:
  contrail.bgp_router_present:
  - name: {{ bgp_router.get('name', bgp_router_name) }}
  - ip_address: {{ bgp_router.ip_address }}
  - type: {{ bgp_router.type }}
  - asn: {{ bgp_router.get('asn', 64512) }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'

{%- endfor %}

{%- for analytics_node_name, analytics_node in client.get('analytics_node', {}).items() %}

opencontrail_client_analytics_node_{{ analytics_node_name }}:
  contrail.analytics_node_present:
  - name: {{ analytics_node.get('name', analytics_node_name) }}
  - ip_address: {{ analytics_node.ip_address }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'

{%- endfor %}

{%- for database_node_name, database_node in client.get('database_node', {}).items() %}

opencontrail_client_database_node_{{ database_node_name }}:
  contrail.database_node_present:
  - name: {{ database_node.get('name', database_node_name) }}
  - ip_address: {{ database_node.ip_address }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'

{%- endfor %}

{%- for linklocal_service_name, linklocal_service in client.get('linklocal_service', {}).items() %}

opencontrail_client_linklocal_service_{{ linklocal_service_name }}:
  contrail.linklocal_service_present:
  - name: {{ linklocal_service.get('name', linklocal_service_name) }}
  - lls_ip: {{ linklocal_service.get('lls_ip') }}
  - lls_port: {{ linklocal_service.get('lls_port') }}
  - ipf_addresses: {{ linklocal_service.get('ipf_addresses') }}
  - ipf_port: {{ linklocal_service.get('ipf_port') }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'

{%- endfor %}

{%- for physical_router_name, physical_router in client.get('physical_router', {}).items() %}

opencontrail_client_physical_router_{{ physical_router_name }}:
  contrail.physical_router_present:
  - name: {{ physical_router.name }}
  - dataplane_ip: {{ physical_router.dataplane_ip }}
  - management_ip: {{ physical_router.get('management_ip') }}
  - vendor_name: {{ physical_router.get('vendor_name') }}
  - product_name: {{ physical_router.get('product_name') }}
  - vnc_managed: {{ physical_router.get('vnc_managed', True) }}
  - agents: {{ physical_router.get('agents') }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'

{%- for physical_interface_name, physical_interface in physical_router.get('interface', {}).items() %}

opencontrail_client_physical_interface_{{ physical_interface_name }}:
  contrail.physical_interface_present:
  - name: {{ physical_interface_name }}
  - physical_router: {{ physical_router_name }}
  - requires:
    - opencontrail_client_physical_router_{{ physical_router_name }}


{%- for logical_interface_name, logical_interface in physical_interface.get('logical_interface', {}).items() %}

{%- for virtual_machine_interface_name, virtual_machine_interface in logical_interface.get('virtual_machine_interface', {}).items() %}

opencontrail_client_virtual_machine_interface_{{ virtual_machine_interface_name }}:
  contrail.virtual_machine_interface_present:
  - name: {{ virtual_machine_interface.name }}
  - virtual_network: {{ virtual_machine_interface.virtual_network }}
  - ip_address: {{ virtual_machine_interface.get('ip_address') }}
  - mac_address: {{ virtual_machine_interface.get('mac_address') }}
  - security_group: {{ virtual_machine_interface.get('security_group') }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'
  - requires_in:
    - opencontrail_client_logical_interface_{{ logical_interface_name }}

{%- endfor %} # end for virtual_machine_interface

opencontrail_client_logical_interface_{{ logical_interface_name }}:
  contrail.logical_interface_present:
  - name: {{ logical_interface.name }}
  - parent_names:
    - {{ physical_interface.name }}
    - {{ physical_router.name }}
  - parent_type: 'physical-interface'
  - vlan_tag: {{ logical_interface.get('vlan_tag') }}
  - interface_type: {{ logical_interface.get('interface_type', 'L2') }}
  - vmis: {{ logical_interface.get('virtual_machine_interface', {}) }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'
  - requires:
    - opencontrail_client_physical_interface_{{ physical_interface_name }}

{%- endfor %} # end for logical_interaface

{%- endfor %} # end for physical_interface

{%- endfor %} # end for physical_router

{%- endif %}
