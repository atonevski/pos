# Ionic Starter App
#
#
# app.coffee
# POS
#
# angular.module is a global place for creating, registering and retrieving Angular modules
# 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
# the 2nd parameter is an array of 'requires'
angular.module('app', ['ionic', 'ngCordova', 'app.map'])

.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'root', {
      url:          '/'
      templateUrl:  'views/map/current.html'
      controller:   'MapCurrentPosition'
    }
    .state 'search', {
      url:          '/search'
      templateUrl:  'views/map/search.html'
      controller:   'MapSearch'
    }
    .state 'cities', {
      url:          '/cities'
      templateUrl:  'views/map/cities.html'
      controller:   'MapCities'
    }

  $urlRouterProvider.otherwise '/'

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
, $ionicScrollDelegate, $ionicPosition, $window, $http, $ionicSideMenuDelegate) ->

  # side menu
  $scope.toggleLeft = () -> $ionicSideMenuDelegate.toggleLeft()

  $ionicPlatform.ready () ->
    opts =
      timeout: 10000
      enableHighAccuracy: yes
    $cordovaGeolocation
      .getCurrentPosition opts
      .then (pos) ->
        $scope.position = pos
        console.log "Current pos: ", pos.coords.latitude, pos.coords.longitude
      , (err) ->
        console.log "Get current pos err: ", err
        alert "Get current pos err: #{ err.code }"

    # navigator.geolocation.getCurrentPosition (pos) ->
    #   $scope.position = pos
    #   console.log "Current pos: ", pos.coords.latitude, pos.coords.longitude
    # , (err) ->
    #    console.log "Get current pos err: ", err
    #    alert "Get current pos err: #{ err.code }"
    # , opts
    
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
  
 
  # read all poses
  $http.get 'data/pos.json'
    .then (response) -> # success
      $scope.poses = response.data
      console.log 'Done reading poses.json'
    , (response) -> # error
      console.log "pos.json error: (#{ response.status }) #{ response.data } #{ response.statusText }"

  # read all cities
  $http.get 'data/cities.json'
    .then (response) -> # success
      $scope.cities = response.data
      console.log 'Done reading citites.json'
    , (response) -> # error
      console.log "cities.json error: (#{ response.status }) #{ response.data } #{ response.statusText }"

