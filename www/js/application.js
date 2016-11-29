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
}).controller('Main', function($scope, $cordovaGeolocation, $ionicPlatform, $ionicScrollDelegate, $ionicPosition, $window) {
  var el, offset, redIcon;
  $scope.map = L.map('mapid').fitWorld();
  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiYXRvbmV2c2tpIiwiYSI6ImNpdzBndWY0azAwMXoyb3BqYXU2NDhoajEifQ.ESeiramSy2FmzU_XyIT6IQ', {
    maxZoom: 18,
    id: 'mapbox.streets'
  }).addTo($scope.map);
  $scope.map.on('locationerror', function(e) {
    return console.log("Leaflet loc err: ", e);
  });
  $scope.map.locate({
    setView: true,
    maxZoom: 16
  });
  redIcon = new L.Icon({
    iconUrl: 'img/purple-marker-icon.png'
  });
  $scope.map.setView([41.993667, 21.4450906], 10);
  L.marker([41.993667, 21.4450906], {
    icon: redIcon
  }).bindPopup("This is your loc's <strong>popup</strong>").addTo($scope.map);
  $ionicPlatform.ready(function() {
    var opts;
    opts = {
      timeout: 4000,
      enableHighAccuracy: false
    };
    return $cordovaGeolocation.getCurrentPosition(opts).then(function(pos) {
      $scope.pos = pos;
      return console.log("Current pos: ", pos.coords.latitude, pos.coords.longitude);
    }, function(err) {
      return console.log("Get current pos err: ", err);
    });
  });
  el = angular.element(document.querySelector('#mapid'));
  offset = $ionicPosition.offset(el);
  console.log('mapid offset (top, left): ', offset.top, offset.left);
  console.log("WxH: " + window.innerWidth + "x" + window.innerHeight);
  el[0].style.height = window.innerHeight - offset.top + 'px';
  $scope.$on('$rootScope.orientation.change', function() {
    return console.log('Device orientation changed!!!');
  });
  return angular.element($window).bind('resize', function() {
    console.log('Window size changed: ', $window.innerWidth + "x" + $window.innerHeight);
    document.getElementById("mapid").style.height = window.innerHeight - offset.top + 'px';
    return $scope.map.setView([41.993667, 21.4450906], 10);
  });
});
