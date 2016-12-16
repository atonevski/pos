#
# map.coffee
# POS
#

angular.module 'app.map', []

.controller 'MapCurrentPosition', ($scope, $rootScope, $window
, $ionicScrollDelegate, $ionicPosition, $cordovaVibration) ->
  $scope.map = L.map('mapid').fitWorld()
  L.tileLayer 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiYXRvbmV2c2tpIiwiYSI6ImNpdzBndWY0azAwMXoyb3BqYXU2NDhoajEifQ.ESeiramSy2FmzU_XyIT6IQ', {
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

  $scope.map.on 'click', (e) ->
    alert "Покажа на позиција " + e.latlng
    $cordovaVibration.vibrate 250

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
 
  # watch position change/ready
  $scope.$watch 'position', (n, o) ->
    return unless n?
    if $scope.positionMarker?
      $scope.map.removeLayer $scope.positionMarker
    $scope.positionMarker =   L.marker [
        $scope.position.coords.latitude,
        $scope.position.coords.longitude,
      ], { icon: redIcon }
      .bindPopup """
          Ова е твојата тековна позиција:<br />
          <strong>#{ $scope.position.coords.latitude.toFixed 6 },
          #{ $scope.position.coords.longitude.toFixed 6 }</strong>
        """
      .addTo $scope.map
      .openPopup()

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
            <hr />
            <address>
              #{ pos.address } <br />
              #{ pos.city } <br />
              тел.: #{ pos.telephone } <br />
            </address>
            </address>
          """
        .addTo $scope.map

  $scope.$on '$ionicView.enter', () ->
    if $scope.position?
      # center around current position
      $scope.map.setView [
        $scope.position.coords.latitude,
        $scope.position.coords.longitude,
      ], 15
      # and popUp marker
      $scope.positionMarker.openPopup()
    

.controller 'MapCities', ($scope, $rootScope, $window
, $ionicScrollDelegate, $ionicPosition, $cordovaVibration) ->

  $scope.map = L.map('cities-map-id').fitWorld()

  L.tileLayer 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiYXRvbmV2c2tpIiwiYSI6ImNpdzBndWY0azAwMXoyb3BqYXU2NDhoajEifQ.ESeiramSy2FmzU_XyIT6IQ', {
    maxZoom: 18
    id: 'mapbox.streets'
  }
  .addTo $scope.map

  $scope.map.on 'locationerror', (e) -> console.log "Leaflet loc err: ", e
  $scope.map.on 'locationfound', (e) ->
    console.log 'Location found: ', e
    # alert "Location found @: #{ e.latitude }, #{ e.longitude }"

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

  $scope.map.on 'click', (e) ->
    alert "Покажа на позиција " + e.latlng
    $cordovaVibration.vibrate 250

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

  # watch position change/ready
  $scope.$watch 'position', (n, o) ->
    return unless n?
    if $scope.positionMarker?
      $scope.map.removeLayer $scope.positionMarker
    $scope.positionMarker =   L.marker [
        $scope.position.coords.latitude,
        $scope.position.coords.longitude,
      ], { icon: redIcon }
      .addTo $scope.map
      .bindPopup """
          Ова е твојата тековна позиција:<br />
          <strong>#{ $scope.position.coords.latitude.toFixed 6 },
          #{ $scope.position.coords.longitude.toFixed 6 }</strong>
        """

  # watch poses change
  $scope.$watch 'poses', (n, o) ->
    return unless n?
    console.log "We have #{ $scope.poses.length } poses to add"
    for pos in $scope.poses
      L.marker [
          pos.latitude,
          pos.longitude,
        ], { icon: greenIcon }
        .addTo $scope.map
        .bindPopup """
            <strong>#{ pos.name }</strong> (#{ pos.id })<br />
            <hr />
            <address>
              #{ pos.address } <br />
              #{ pos.city } <br />
              тел.: #{ pos.telephone } <br />
            </address>
          """


  $scope.newSelection = (c) ->
    console.log 'New selection: ', c
    $scope.map.setView [
      c.latitude,
      c.longitude,
    ], c.zoomLevel


.controller 'MapSearch', ($scope, $rootScope, $window
, $ionicScrollDelegate, $ionicPosition, $cordovaVibration) ->


  $scope.map = L.map('search-map-id').fitWorld()

  L.tileLayer 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiYXRvbmV2c2tpIiwiYSI6ImNpdzBndWY0azAwMXoyb3BqYXU2NDhoajEifQ.ESeiramSy2FmzU_XyIT6IQ', {
    maxZoom: 18
    id: 'mapbox.streets'
  }
  .addTo $scope.map

  $scope.map.on 'locationerror', (e) -> console.log "Leaflet loc err: ", e
  $scope.map.on 'locationfound', (e) ->
    console.log 'Location found: ', e
    alert "Location found @: #{ e.latitude }, #{ e.longitude }"

  $scope.searchResults =
    hide: no
    pos:  null
  $scope.selectTerminal = (id) ->
    return unless id
    id = parseInt id
    console.log "Terminal #{ id } selected"
    $scope.searchResults.hide = yes
    $scope.searchResults.pos = (pos for pos in $scope.poses when pos.id is id)[0]
    $scope.map.setView [
        $scope.searchResults.pos.latitude,
        $scope.searchResults.pos.longitude
    ], 15
    $scope.searchResults.pos.marker.openPopup()


  $scope.map.setView [
    41.997346199999996, 21.4279956
    ], 15
  # $scope.map.locate { setView: yes, maxZoom: 16 }

  redIcon   = new L.Icon { iconUrl: 'img/red-marker-icon.png' }
  greenIcon = new L.Icon { iconUrl: 'img/green-marker-icon.png' }

  # resize map div
  el      = angular.element document.querySelector '#search-map-id'
  offset  = $ionicPosition.offset el
  console.log 'search-map-id offset (top, left): ', offset.top, offset.left

  console.log "WxH: #{ window.innerWidth }x#{ window.innerHeight }"

  # setting map's height
  el[0].style.height = window.innerHeight - offset.top + 'px'
  
  # or alternativelly:
  # document
  #   .getElementById("cities-map-id")
  #   .style.height = window.innerHeight - offset.top + 'px'
  #

  $scope.map.on 'click', (e) ->
    alert "Покажа на позиција " + e.latlng
    $cordovaVibration.vibrate 250

  # detect window size change
  angular
    .element $window
    .bind 'resize', () ->
      console.log 'Window size changed: ', "#{ $window.innerWidth }x#{ $window.innerHeight }"
      document
        .getElementById("search-map-id")
        .style.height = $window.innerHeight - offset.top + 'px'

  # watch position change/ready
  $scope.$watch 'position', (n, o) ->
    return unless n?
    if $scope.positionMarker?
      $scope.map.removeLayer $scope.positionMarker
    $scope.positionMarker =   L.marker [
        $scope.position.coords.latitude,
        $scope.position.coords.longitude,
      ], { icon: redIcon }
      .addTo $scope.map
      .bindPopup """
          Ова е твојата тековна позиција:<br />
          <strong>#{ $scope.position.coords.latitude.toFixed 6 },
          #{ $scope.position.coords.longitude.toFixed 6 }</strong>
        """

  # watch poses change
  $scope.$watch 'poses', (n, o) ->
    return unless n?
    console.log "We have #{ $scope.poses.length } poses to add"
    for pos in $scope.poses
      marker = L.marker [
          pos.latitude,
          pos.longitude,
        ], { icon: greenIcon }
        .addTo $scope.map
        .bindPopup """
            <strong>#{ pos.name }</strong> (#{ pos.id })<br />
            <hr />
            <address>
              #{ pos.address } <br />
              #{ pos.city } <br />
              тел.: #{ pos.telephone } <br />
            </address>
          """
      pos.marker = marker
