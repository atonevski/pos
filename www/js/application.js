angular.module('app', ['ionic', 'ngCordova']).run(function($ionicPlatform) {
  return $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);
    }
    if (window.StatusBar) {
      return StatusBar.styleDefault();
    }
  });
}).controller('Main', function($scope, $cordovaGeolocation, $ionicPlatform) {
  return $ionicPlatform.ready(function() {
    var opts;
    opts = {
      timeout: 1000,
      enableHighAccuracy: false
    };
    return $cordovaGeolocation.getCurrentPosition(opts).then(function(pos) {
      $scope.pos = pos;
      return console.log("Current pos: ", pos);
    }, function(err) {
      return console.log("Get current pos err: ", err);
    });
  });
});
