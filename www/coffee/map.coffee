#
# map.coffee
# POS
#

angular.module 'app.map', []

.controller 'MapCurrentPosition', ($scope, $rootScope, $window
, $ionicScrollDelegate, $ionicPosition) ->
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
          This is your current position<br />
          <strong>#{ $scope.position.coords.latitude },
          #{ $scope.position.coords.longitude }</strong>
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
            <address>
              address: #{ pos.address } <br />
              telephone: #{ pos.telephone } <br />
            </address>
          """
        .addTo $scope.map


.controller 'MapCities', ($scope, $rootScope, $window
, $ionicScrollDelegate, $ionicPosition) ->

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

  # erase this:
  $scope.map.on 'click', (e) -> alert "You clicked @ " + e.latlng

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
          This is your current position<br />
          <strong>#{ $scope.position.coords.latitude },
          #{ $scope.position.coords.longitude }</strong>
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
            <address>
              address: #{ pos.address } <br />
              telephone: #{ pos.telephone } <br />
            </address>
          """


  $scope.newSelection = (c) ->
    console.log 'New selection: ', c
    $scope.map.setView [
      c.latitude,
      c.longitude,
    ], c.zoomLevel


.controller 'MapSearch', ($scope, $rootScope, $window
, $ionicScrollDelegate, $ionicPosition) ->

  $scope.hideSearchResults = no
  $scope.selectTerminal = (id) ->
    return unless id
    id = parseInt id
    console.log "Terminal #{ id } selected"
    $scope.hideSearchResults = yes
    for pos in $scope.poses when pos.id is id
      $scope.map.setView [
        pos.latitude, pos.longitude
      ], 15
    # $scope.$apply()

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

  # erase this:
  $scope.map.on 'click', (e) -> alert "You clicked @ " + e.latlng

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
          This is your current position<br />
          <strong>#{ $scope.position.coords.latitude },
          #{ $scope.position.coords.longitude }</strong>
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
            <address>
              address: #{ pos.address } <br />
              telephone: #{ pos.telephone } <br />
            </address>
          """
      pos.marker = marker
