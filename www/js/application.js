angular.module('app', ['ionic', 'ngCordova', 'app.map']).config(function($stateProvider, $urlRouterProvider) {
  $stateProvider.state('root', {
    url: '/',
    templateUrl: 'views/map/current.html',
    controller: 'MapCurrentPosition'
  }).state('cities', {
    url: '/cities',
    templateUrl: 'views/map/cities.html',
    controller: 'MapCities'
  });
  return $urlRouterProvider.otherwise('/');
}).run(function($ionicPlatform) {
  return $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);
    }
    if (window.StatusBar) {
      return StatusBar.styleDefault();
    }
  });
}).controller('Main', function($scope, $cordovaGeolocation, $ionicPlatform, $ionicScrollDelegate, $ionicPosition, $window, $http, $ionicSideMenuDelegate) {
  $scope.toggleLeft = function() {
    return $ionicSideMenuDelegate.toggleLeft();
  };
  $ionicPlatform.ready(function() {
    var opts;
    opts = {
      timeout: 8000,
      enableHighAccuracy: false
    };
    return $cordovaGeolocation.getCurrentPosition(opts).then(function(pos) {
      $scope.position = pos;
      return console.log("Current pos: ", pos.coords.latitude, pos.coords.longitude);
    }, function(err) {
      return console.log("Get current pos err: ", err);
    });
  });
  $http.get('data/pos.json').then(function(response) {
    $scope.poses = response.data;
    return console.log('Done reading poses.json');
  }, function(response) {
    return console.log("pos.json error: (" + response.status + ") " + response.data + " " + response.statusText);
  });
  return $http.get('data/cities.json').then(function(response) {
    $scope.cities = response.data;
    return console.log('Done reading citites.json');
  }, function(response) {
    return console.log("cities.json error: (" + response.status + ") " + response.data + " " + response.statusText);
  });
});

angular.module('app.map', []).controller('MapCurrentPosition', function($scope, $rootScope, $window, $ionicScrollDelegate, $ionicPosition) {
  var el, greenIcon, offset, redIcon;
  $scope.map = L.map('mapid').fitWorld();
  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiYXRvbmV2c2tpIiwiYSI6ImNpdzBndWY0azAwMXoyb3BqYXU2NDhoajEifQ.ESeiramSy2FmzU_XyIT6IQ', {
    maxZoom: 18,
    id: 'mapbox.streets'
  }).addTo($scope.map);
  $scope.map.on('locationerror', function(e) {
    return console.log("Leaflet loc err: ", e);
  });
  $scope.map.setView([41.997346199999996, 21.4279956], 15);
  $scope.map.locate({
    setView: true,
    maxZoom: 16
  });
  redIcon = new L.Icon({
    iconUrl: 'img/red-marker-icon.png'
  });
  greenIcon = new L.Icon({
    iconUrl: 'img/green-marker-icon.png'
  });
  el = angular.element(document.querySelector('#mapid'));
  offset = $ionicPosition.offset(el);
  console.log('mapid offset (top, left): ', offset.top, offset.left);
  console.log("WxH: " + window.innerWidth + "x" + window.innerHeight);
  el[0].style.height = window.innerHeight - offset.top + 'px';
  angular.element($window).bind('resize', function() {
    console.log('Window size changed: ', $window.innerWidth + "x" + $window.innerHeight);
    document.getElementById("mapid").style.height = $window.innerHeight - offset.top + 'px';
    return $scope.map.setView([$scope.position.coords.latitude, $scope.position.coords.longitude], 15);
  });
  $scope.$watch('position', function(n, o) {
    if (n == null) {
      return;
    }
    if ($scope.positionMarker != null) {
      $scope.map.removeLayer($scope.positionMarker);
    }
    return $scope.positionMarker = L.marker([$scope.position.coords.latitude, $scope.position.coords.longitude], {
      icon: redIcon
    }).bindPopup("This is your current position").addTo($scope.map);
  });
  return $scope.$watch('poses', function(n, o) {
    var i, len, pos, ref, results;
    if (n == null) {
      return;
    }
    console.log("We have " + $scope.poses.length + " poses to add");
    ref = $scope.poses;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      pos = ref[i];
      results.push(L.marker([pos.latitude, pos.longitude], {
        icon: greenIcon
      }).bindPopup("<strong>" + pos.name + "</strong> (" + pos.id + ")<br />\n<address>\n  address: " + pos.address + " <br />\n  telephone: " + pos.telephone + " <br />\n</address>").addTo($scope.map));
    }
    return results;
  });
}).controller('MapCities', function($scope, $rootScope, $window, $ionicScrollDelegate, $ionicPosition) {
  var el, greenIcon, offset, redIcon;
  console.log('Entered MapCities');
  console.log("$scope.map? = " + ($scope.map != null));
  $scope.map = L.map('cities-map-id').fitWorld();
  console.log("$scope.map? = " + ($scope.map != null));
  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiYXRvbmV2c2tpIiwiYSI6ImNpdzBndWY0azAwMXoyb3BqYXU2NDhoajEifQ.ESeiramSy2FmzU_XyIT6IQ', {
    maxZoom: 18,
    id: 'mapbox.streets'
  }).addTo($scope.map);
  $scope.map.on('locationerror', function(e) {
    return console.log("Leaflet loc err: ", e);
  });
  $scope.map.setView([41.997346199999996, 21.4279956], 15);
  $scope.map.locate({
    setView: true,
    maxZoom: 16
  });
  redIcon = new L.Icon({
    iconUrl: 'img/red-marker-icon.png'
  });
  greenIcon = new L.Icon({
    iconUrl: 'img/green-marker-icon.png'
  });
  el = angular.element(document.querySelector('#cities-map-id'));
  offset = $ionicPosition.offset(el);
  console.log('cities-map-id offset (top, left): ', offset.top, offset.left);
  console.log("WxH: " + window.innerWidth + "x" + window.innerHeight);
  el[0].style.height = window.innerHeight - offset.top + 'px';
  angular.element($window).bind('resize', function() {
    console.log('Window size changed: ', $window.innerWidth + "x" + $window.innerHeight);
    return document.getElementById("cities-map-id").style.height = $window.innerHeight - offset.top + 'px';
  });
  $scope.$watch('position', function(n, o) {
    if (n == null) {
      return;
    }
    if ($scope.positionMarker != null) {
      $scope.map.removeLayer($scope.positionMarker);
    }
    return $scope.positionMarker = L.marker([$scope.position.coords.latitude, $scope.position.coords.longitude], {
      icon: redIcon
    }).bindPopup("This is your current position<br />").addTo($scope.map);
  });
  $scope.$watch('poses', function(n, o) {
    var i, len, pos, ref, results;
    if (n == null) {
      return;
    }
    console.log("We have " + $scope.poses.length + " poses to add");
    ref = $scope.poses;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      pos = ref[i];
      results.push(L.marker([pos.latitude, pos.longitude], {
        icon: greenIcon
      }).bindPopup("<strong>" + pos.name + "</strong> (" + pos.id + ")<br />\n<address>\n  address: " + pos.address + " <br />\n  telephone: " + pos.telephone + " <br />\n</address>").addTo($scope.map));
    }
    return results;
  });
  return $scope.newSelection = function(c) {
    console.log('New selection: ', c);
    return $scope.map.setView([c.latitude, c.longitude], c.zoomLevel);
  };
});
