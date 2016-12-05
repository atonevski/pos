#
# map.coffee
# POS
#

angular.module 'app.map', []

.controller 'MapCurrentPosition', ($scope, $rootScope, $window
, $ionicScrollDelegate, $ionicPosition) ->
  $scope.map = L.map('mapid').fitWorld()
  L.tileLayer 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiYXRvbmV2c2tpIiwiYSI6ImNpdzBndWY0azAwMXoyb3BqYXU2NDhoajEifQ.ESeiramSy2FmzU_XyIT6IQ', {
    # attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>'
    maxZoom: 18
    id: 'mapbox.streets'
  }
  .addTo $scope.map

  $scope.map.on 'locationerror', (e) -> console.log "Leaflet loc err: ", e

  $scope.map.setView [
    41.997346199999996, 21.4279956
    ], 15
  $scope.map.locate { setView: yes, maxZoom: 16 }

  redIcon   = new L.Icon { iconUrl: 'img/red-marker-icon.png' }
  greenIcon = new L.Icon { iconUrl: 'img/green-marker-icon.png' }

  # resize map div
  el      = angular.element document.querySelector '#mapid'
  offset  = $ionicPosition.offset el
  console.log 'mapid offset (top, left): ', offset.top, offset.left

  console.log "WxH: #{ window.innerWidth }x#{ window.innerHeight }"

  # setting map's height
  el[0].style.height = window.innerHeight - offset.top + 'px'
  
  # or alternativelly:
  # document
  #   .getElementById("mapid")
  #   .style.height = window.innerHeight - offset.top + 'px'
  #

  # detect window size change
  angular
    .element $window
    .bind 'resize', () ->
      console.log 'Window size changed: ', "#{ $window.innerWidth }x#{ $window.innerHeight }"
      document
        .getElementById("mapid")
        .style.height = $window.innerHeight - offset.top + 'px'
      $scope.map.setView [
        $scope.position.coords.latitude,
        $scope.position.coords.longitude,
      ], 15
 
  # watch pos change/ready
  $scope.$watch 'position', (n, o) ->
    return unless n?
    if $scope.positionMarker?
      $scope.map.removeLayer $scope.positionMarker
    $scope.positionMarker =   L.marker [
        $scope.position.coords.latitude,
        $scope.position.coords.longitude,
      ], { icon: redIcon }
      .bindPopup "This is your current position"
      .addTo $scope.map

  # watch poses change
  $scope.$watch 'poses', (n, o) ->
    return unless n?
    console.log "We have #{ $scope.poses.length } poses to add"
    for pos in $scope.poses
      L.marker [
          pos.latitude,
          pos.longitude,
        ], { icon: greenIcon }
        .bindPopup """
            <strong>#{ pos.name }</strong> (#{ pos.id })<br />
            <address>
              address: #{ pos.address } <br />
              telephone: #{ pos.telephone } <br />
            </address>
          """
        .addTo $scope.map


.controller 'MapCities', ($scope, $rootScope, $window
, $ionicScrollDelegate, $ionicPosition) ->
  
  console.log 'Entered MapCities'

  console.log "$scope.map? = #{ $scope.map? }"

  $scope.map = L.map('cities-map-id').fitWorld()

  console.log "$scope.map? = #{ $scope.map? }"

  L.tileLayer 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiYXRvbmV2c2tpIiwiYSI6ImNpdzBndWY0azAwMXoyb3BqYXU2NDhoajEifQ.ESeiramSy2FmzU_XyIT6IQ', {
    # attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>'
    maxZoom: 18
    id: 'mapbox.streets'
  }
  .addTo $scope.map

  $scope.map.on 'locationerror', (e) -> console.log "Leaflet loc err: ", e

  $scope.map.setView [
    41.997346199999996, 21.4279956
    ], 15
  $scope.map.locate { setView: yes, maxZoom: 16 }

  redIcon   = new L.Icon { iconUrl: 'img/red-marker-icon.png' }
  greenIcon = new L.Icon { iconUrl: 'img/green-marker-icon.png' }

  # resize map div
  el      = angular.element document.querySelector '#cities-map-id'
  offset  = $ionicPosition.offset el
  console.log 'cities-map-id offset (top, left): ', offset.top, offset.left

  console.log "WxH: #{ window.innerWidth }x#{ window.innerHeight }"

  # setting map's height
  el[0].style.height = window.innerHeight - offset.top + 'px'
  
  # or alternativelly:
  # document
  #   .getElementById("cities-map-id")
  #   .style.height = window.innerHeight - offset.top + 'px'
  #

  # detect window size change
  angular
    .element $window
    .bind 'resize', () ->
      console.log 'Window size changed: ', "#{ $window.innerWidth }x#{ $window.innerHeight }"
      document
        .getElementById("cities-map-id")
        .style.height = $window.innerHeight - offset.top + 'px'
      # $scope.map.setView [
      #   $scope.position.coords.latitude,
      #   $scope.position.coords.longitude,
      # ], 15

  # watch pos change/ready
  $scope.$watch 'position', (n, o) ->
    return unless n?
    if $scope.positionMarker?
      $scope.map.removeLayer $scope.positionMarker
    $scope.positionMarker =   L.marker [
        $scope.position.coords.latitude,
        $scope.position.coords.longitude,
      ], { icon: redIcon }
      .bindPopup "This is your current position"
      .addTo $scope.map

  # watch poses change
  $scope.$watch 'poses', (n, o) ->
    return unless n?
    console.log "We have #{ $scope.poses.length } poses to add"
    for pos in $scope.poses
      L.marker [
          pos.latitude,
          pos.longitude,
        ], { icon: greenIcon }
        .bindPopup """
            <strong>#{ pos.name }</strong> (#{ pos.id })<br />
            <address>
              address: #{ pos.address } <br />
              telephone: #{ pos.telephone } <br />
            </address>
          """
        .addTo $scope.map


  $scope.newSelection = (c) ->
    console.log 'New selection: ', c
    $scope.map.setView [
      c.latitude,
      c.longitude,
    ], c.zoomLevel
