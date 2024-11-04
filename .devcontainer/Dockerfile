version: '3'
services:
  manager:
    build: 
      context: .
      dockerfile: manager.Dockerfile
    networks:
      snmpnet:
        ipv4_address: 10.0.123.2

  agent:
    build:
      context: .
      dockerfile: agent.Dockerfile
    networks:
      snmpnet:
        ipv4_address: 10.0.123.3

networks:
  snmpnet:
    ipam:
      config:
        - subnet: 10.0.123.0/24
