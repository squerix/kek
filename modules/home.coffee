bunyan 					= require 'bunyan'
log 					= bunyan.createLogger {name: 'kek/modules/home'}
rankingModule = require './ranking'

exports.champions = (callback) ->
  rankingModule.apiRankingChampions (r) ->
    callback r

exports.roles = (callback) ->
  Summoner.find {}, (e, summoners) ->
    if e
      log.error e
    if summoners.length
      roles = {}
      for summoner in summoners
        try
          if summoner.data.championMastery.rolesPoints
            summoner = summoner.toObject()
            cachedRoles = summoner.data.championMastery.rolesPoints
            cachedRolesArray = Object.keys(summoner.data.championMastery.rolesPoints)
            for i of cachedRolesArray
              if roles[cachedRolesArray[i]]
                roles[cachedRolesArray[i]] += cachedRoles[cachedRolesArray[i]]
              else
                roles[cachedRolesArray[i]] = cachedRoles[cachedRolesArray[i]]
        catch e
          log.error e

      rolesArray = Object.keys(roles).map (key) -> [key, roles[key]]
      rolesArray.sort (a, b) -> b[1] - a[1]
      roles = {}
      roles[role[0]] = role[1] for role in rolesArray

      callback {
        success: true
        roles: roles
      }

exports.summoners = (callback) ->
  Summoner.find {}, 'identity.name identity.region data.championMastery.rolesPoints',
  (e, cachedSummoners) ->
    if e
      log.error e
    if cachedSummoners.length
      rolesPoints = {
        "Assassin": 0
        "Fighter": 0
        "Mage": 0
        "Marksman": 0
        "Tank": 0
        "Support": 0
      }
      rolesSummoners = {}

      for summoner in cachedSummoners
        try
          roles = summoner.data.championMastery.rolesPoints
          for role in Object.keys(roles)
            if roles[role] > rolesPoints[role]
              rolesSummoners[role] = {
                name: summoner.identity.name
                region: summoner.identity.region
              }
              rolesPoints[role] = roles[role]
        catch e
          log.error e

      roles = {}
      for role in Object.keys(rolesPoints)
        roles[role] = {
          name: rolesSummoners[role].name
          region: rolesSummoners[role].region
          points: rolesPoints[role]
        }

      callback {
        success: true
        roles: roles
      }
