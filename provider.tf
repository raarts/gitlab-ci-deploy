## MAJOR CLOUD

provider "alicloud" { }           # AliCloud
provider "aws" { }                # Amazon
provider "azurerm" { }            # Azure Provider Resource Manager
provider "google" { }             # Google
provider "oraclepaas" { }         # Oracle Cloud Platform Provider
provider "opc" { }                # Oracle Cloud Infrastructure Classic Provider
provider "vsphere" { }            # VMware vSphere

## CLOUD

provider "arukas" { }             # Arukas
provider "clc" { }                # Century Link Cloud
provider "cloudscale" { }         # CloudScale
provider "cloudstack" { }         # Cloud Stack 
provider "digitalocean" { }       # Digital Ocean
provider "fastly" { }             # Fastly
provider "heroku" { }             # Heroku
provider "openstack" { }          # OpenStack
provider "opentelekomcloud" { }   # OpenTelekomCloud
provider "ovh" { }                # OVH
provider "packet" { }             # Packet
provider "profitbricks" { }       # ProfitBricks
provider "scaleway" { }           # ScaleWay
provider "softlayer" { }          # SoftLayer
provider "triton" { }             # Joyent Triton
provider "vcd" { }                # VMware vCloud Director
provider "oneandone"{ }           # 1&1

## Infrastructure Software Providers

provider "chef" { }               # Chef
provider "consul" { }             # Consul
provider "kubernetes" { }         # Kubernetes
provider "mailgun" { }            # Mailgun
provider "nomad" { }              # HashiCorp Nomad
provider "rabbitmq" { }           # RabbitMQ
provider "rancher" { }            # Rancher
provider "rundeck" { }            # Rundeck
provider "spotinst" { }           # Spotinst
provider "terraform" { }          # Terraform
provider "atlas" { }              # Terraform Enterprise (formerly Atlas)
provider "vault" { }              # HashiCorp Vault

## Network Providers
provider "cloudflare" { }         # Cloudflare
provider "dns" { }                # DNS
provider "dnsimple" { }           # DNSimple
provider "dme" { }                # DNSMadeEasy
provider "ns1" { }                # NS1
provider "panos" { }              # PANOS
provider "powerdns" { }           # PowerDNS
provider "ultradns" { }           # UltraDNS

## Version Control Providers

provider "bitbucket" { }          # BitBucket
provider "github" { }             # Github
provider "gitlab" { }             # GitLab

## Monitoring & System Management

provider "circonus" { }           # Circonus
provider "datadog" { }            # Datadog
provider "dyn" { }                # Dyn
provider "grafana" { }            # Grafana
provider "icinga2" { }            # Icinga2
provider "librato" { }            # Librato
provider "logentries" { }         # Logentries
provider "logicmonitor" { }       # LogicMonitor
provider "newrelic" { }           # New Relic
provider "opsgenie" { }           # OpsGenie
provider "pagerduty" { }          # PagerDuty
provider "statuscake" { }         # StatusCake

## Database

provider "influxdb" { }           # InfluxDB
provider "mysql" { }              # MySQL
provider "postgresql" { }         # PostgreSQL

## Miscellaneous

provider "archive" { }            # archive provider
provider "cobbler" { }            # Cobbler
provider "external" { }           # external provider
provider "ignition" { }           # CoreOS Ignition
provider "local" { }              # local files
provider "null" { }               # does nothing
provider "random" { }             # randomness 
provider "template" { }           # templates
provider "tls" { }                # TLS



