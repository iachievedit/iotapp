Example REST API for devices, streams, datapoints, styled after AT&T's M2X.

```
curl -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache" -H "Postman-Token: 4c870c04-56c6-7062-2dfb-82c51b4ca6a2" -d '{"name":"BeagleBone",
 "serial":"N9TT-9G0F-B7GF-RXNC",
 "location":{
  "latitude":-34.8836,
  "longitude":-56.1819
  },
  "streams":[
      {"name":"cpu-occupancy"},
      {"name":"free-memory"}
  ]
}' 'http://localhost:8080/api/v1/devices'
```
