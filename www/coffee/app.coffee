# Ionic Starter App
#
# angular.module is a global place for creating, registering and retrieving Angular modules
# 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
# the 2nd parameter is an array of 'requires'
angular.module('app', ['ionic', 'ngCordova'])

.run ($ionicPlatform) ->
  $ionicPlatform.ready () ->
    if window.cordova && window.cordova.plugins.Keyboard
      # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
      # for form inputs)
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar yes

      # Don't remove this line unless you know what you are doing. It stops the viewport
      # from snapping when text inputs are focused. Ionic handles this internally for
      # a much nicer keyboard experience.
      cordova.plugins.Keyboard.disableScroll yes
    if window.StatusBar
      StatusBar.styleDefault()

.controller 'Main', ($scope, $cordovaGeolocation, $ionicPlatform
, $ionicScrollDelegate, $ionicPosition, $window) ->

  $scope.map = L.map('mapid').fitWorld()
  L.tileLayer 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiYXRvbmV2c2tpIiwiYSI6ImNpdzBndWY0azAwMXoyb3BqYXU2NDhoajEifQ.ESeiramSy2FmzU_XyIT6IQ', {
    # attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>'
    maxZoom: 18
    id: 'mapbox.streets'
  }
  .addTo $scope.map

  $scope.map.on 'locationerror', (e) -> console.log "Leaflet loc err: ", e

  $scope.map.locate { setView: yes, maxZoom: 16 }

  # red color: '#e85142'
  redIcon = new L.Icon { iconUrl: 'img/purple-marker-icon.png' }
  $scope.map.setView [41.993667, 21.4450906], 10
  L.marker [41.993667, 21.4450906], { icon: redIcon }
    .bindPopup "This is your loc's <strong>popup</strong>"
    .addTo $scope.map
  # $ionicScrollDelegate.resize()

  $ionicPlatform.ready () ->
    opts =
      timeout: 4000
      enableHighAccuracy: no
    $cordovaGeolocation
      .getCurrentPosition opts
      .then (pos) ->
        $scope.pos = pos
        console.log "Current pos: ", pos.coords.latitude, pos.coords.longitude
      , (err) ->
        console.log "Get current pos err: ", err
    
    # wopts =
    #   timeout: 60000
    #   enableHighAccuracy: no
    # watch = $cordovaGeolocation.watchPosition wopts
    # watch.then null
    # , (err) ->
    #   console.log "watch pos err: ", err
    # , (pos) ->
    #   $scope.pos = pos
    #   console.log "Watch position: ", pos
  
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
 
  # here is orientation change detection
  $scope.$on '$rootScope.orientation.change', () ->
    console.log 'Device orientation changed!!!'

  # detect window size change
  angular
    .element $window
    .bind 'resize', () ->
      console.log 'Window size changed: ', "#{ $window.innerWidth }x#{ $window.innerHeight }"
      document
        .getElementById("mapid")
        .style.height = window.innerHeight - offset.top + 'px'
      $scope.map.setView [41.993667, 21.4450906], 10
