{% set MANAGER = salt['grains.get']('master') %}
{% set ENROLLSECRET = salt['pillar.get']('secrets:fleet_enroll-secret') %}
{% set CURRENTPACKAGEVERSION = salt['pillar.get']('static:fleet_packages-version') %}
{% set VERSION = salt['pillar.get']('static:soversion') %}
{% set CUSTOM_FLEET_HOSTNAME = salt['pillar.get']('static:fleet_custom_hostname', None) %}
{% set IMAGEREPO = salt['pillar.get']('static:imagerepo') %}
{%- set FLEETNODE = salt['pillar.get']('static:fleet_node') -%}

{% if CUSTOM_FLEET_HOSTNAME != None and CUSTOM_FLEET_HOSTNAME != '' %}
   {% set HOSTNAME =  CUSTOM_FLEET_HOSTNAME  %}
{% elif FLEETNODE %}
   {% set HOSTNAME = grains.host  %}
{% else %}
   {% set HOSTNAME = salt['pillar.get']('manager:url_base')  %}
{% endif %}

so/fleet:
  event.send:
    - data:
        action: 'genpackages'
        package-hostname: {{ HOSTNAME }}
        role: {{ grains.role }}
        mainip: {{ grains.host }}
        enroll-secret: {{ ENROLLSECRET }}
        current-package-version: {{ CURRENTPACKAGEVERSION }}
        manager: {{ MANAGER }}
        version: {{ VERSION }}
        imagerepo: {{ IMAGEREPO }}