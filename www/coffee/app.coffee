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

.controller 'Main', ($scope, $cordovaGeolocation, $ionicPlatform) ->
  $ionicPlatform.ready () ->
    opts =
      timeout: 1000
      enableHighAccuracy: no
    $cordovaGeolocation
      .getCurrentPosition opts
      .then (pos) ->
        $scope.pos = pos
        # $scope.$apply () -> $scope.pos = qq
        console.log "Current pos: ", pos
      , (err) ->
        console.log "Get current pos err: ", err
    
    # wopts =
    #   timeout: 3000
    #   enableHighAccuracy: no
    # watch = $cordovaGeolocation.watchPosition wopts
    # watch.then null
    # , (err) ->
    #   console.log "watch pos err: ", err
    # , (pos) ->
    #   $scope.pos = pos
    #   console.log "Watch position: ", pos
