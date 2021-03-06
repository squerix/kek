bunyan 					= require 'bunyan'
log 					= bunyan.createLogger {name: 'kek/routes/api-ranking'}
rankingModule 			= require '../modules/ranking'

module.exports = (router) ->
  router.route('/api/ranking/overall')
  .get (req, res) ->
    rankingModule.apiRankingOverall (r) ->
      res.json r

  router.route('/api/ranking/champions')
  .get (req, res) ->
    rankingModule.apiRankingChampions (r) ->
      res.json r

  router.route('/api/ranking/role/:role')
  .get (req, res) ->
    rankingModule.apiRankingRole req.params.role, (r) ->
      res.json r

  router.route('/api/ranking/champion/:champion')
  .get (req, res) ->
    rankingModule.apiRankingChampion req.params.champion, (r) ->
      res.json r

  return router
