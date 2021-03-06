angular.module('app', ['ionic', 'ngCordova', 'app.map']).config(function($stateProvider, $urlRouterProvider) {
  $stateProvider.state('root', {
    url: '/',
    templateUrl: 'views/map/current.html',
    controller: 'MapCurrentPosition'
  }).state('search', {
    url: '/search',
    templateUrl: 'views/map/search.html',
    controller: 'MapSearch'
  }).state('cities', {
    url: '/cities',
    templateUrl: 'views/map/cities.html',
    controller: 'MapCities'
  }).state('about', {
    url: '/about',
    templateUrl: 'views/about/about.html',
    controller: 'About'
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
}).controller('Main', function($scope, $cordovaGeolocation, $ionicPlatform, $ionicScrollDelegate, $ionicPosition, $window, $http, $ionicSideMenuDelegate, $cordovaAppVersion) {
  $scope.toggleLeft = function() {
    return $ionicSideMenuDelegate.toggleLeft();
  };
  $ionicPlatform.ready(function() {
    var opts;
    opts = {
      timeout: 10000,
      enableHighAccuracy: true
    };
    $cordovaGeolocation.getCurrentPosition(opts).then(function(pos) {
      $scope.position = pos;
      return console.log("Current pos: ", pos.coords.latitude, pos.coords.longitude);
    }, function(err) {
      console.log("Get current pos err: ", err);
      return alert("Get current pos err: " + err.code);
    });
    if (window.cordova) {
      $cordovaAppVersion.getVersionNumber().then(function(ver) {
        return $scope.appVersion = ver;
      });
      return $cordovaAppVersion.getAppName().then(function(name) {
        return $scope.appName = name;
      });
    }
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
}).controller('About', function($scope) {
  return console.log($scope.appVersion);
});

angular.module('app.map', []).controller('MapCurrentPosition', function($scope, $rootScope, $window, $ionicScrollDelegate, $ionicPosition, $cordovaVibration) {
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
  $scope.map.on('click', function(e) {
    alert("Покажа на позиција " + e.latlng);
    return $cordovaVibration.vibrate(250);
  });
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
    }).bindPopup("Ова е твојата тековна позиција:<br />\n<strong>" + ($scope.position.coords.latitude.toFixed(6)) + ",\n" + ($scope.position.coords.longitude.toFixed(6)) + "</strong>").addTo($scope.map).openPopup();
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
      }).bindPopup("<strong>" + pos.name + "</strong> (" + pos.id + ")<br />\n<hr />\n<address>\n  " + pos.address + " <br />\n  " + pos.city + " <br />\n  тел.: " + pos.telephone + " <br />\n</address>\n</address>").addTo($scope.map));
    }
    return results;
  });
  return $scope.$on('$ionicView.enter', function() {
    if ($scope.position != null) {
      $scope.map.setView([$scope.position.coords.latitude, $scope.position.coords.longitude], 15);
      return $scope.positionMarker.openPopup();
    }
  });
}).controller('MapCities', function($scope, $rootScope, $window, $ionicScrollDelegate, $ionicPosition, $cordovaVibration) {
  var el, greenIcon, offset, redIcon;
  $scope.map = L.map('cities-map-id').fitWorld();
  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiYXRvbmV2c2tpIiwiYSI6ImNpdzBndWY0azAwMXoyb3BqYXU2NDhoajEifQ.ESeiramSy2FmzU_XyIT6IQ', {
    maxZoom: 18,
    id: 'mapbox.streets'
  }).addTo($scope.map);
  $scope.map.on('locationerror', function(e) {
    return console.log("Leaflet loc err: ", e);
  });
  $scope.map.on('locationfound', function(e) {
    return console.log('Location found: ', e);
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
  $scope.map.on('click', function(e) {
    alert("Покажа на позиција " + e.latlng);
    return $cordovaVibration.vibrate(250);
  });
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
    }).addTo($scope.map).bindPopup("Ова е твојата тековна позиција:<br />\n<strong>" + ($scope.position.coords.latitude.toFixed(6)) + ",\n" + ($scope.position.coords.longitude.toFixed(6)) + "</strong>");
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
      }).addTo($scope.map).bindPopup("<strong>" + pos.name + "</strong> (" + pos.id + ")<br />\n<hr />\n<address>\n  " + pos.address + " <br />\n  " + pos.city + " <br />\n  тел.: " + pos.telephone + " <br />\n</address>"));
    }
    return results;
  });
  return $scope.newSelection = function(c) {
    console.log('New selection: ', c);
    return $scope.map.setView([c.latitude, c.longitude], c.zoomLevel);
  };
}).controller('MapSearch', function($scope, $rootScope, $window, $ionicScrollDelegate, $ionicPosition, $cordovaVibration) {
  var el, greenIcon, offset, redIcon;
  $scope.map = L.map('search-map-id').fitWorld();
  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiYXRvbmV2c2tpIiwiYSI6ImNpdzBndWY0azAwMXoyb3BqYXU2NDhoajEifQ.ESeiramSy2FmzU_XyIT6IQ', {
    maxZoom: 18,
    id: 'mapbox.streets'
  }).addTo($scope.map);
  $scope.map.on('locationerror', function(e) {
    return console.log("Leaflet loc err: ", e);
  });
  $scope.map.on('locationfound', function(e) {
    console.log('Location found: ', e);
    return alert("Location found @: " + e.latitude + ", " + e.longitude);
  });
  $scope.searchResults = {
    hide: false,
    pos: null
  };
  $scope.selectTerminal = function(id) {
    var pos;
    if (!id) {
      return;
    }
    id = parseInt(id);
    console.log("Terminal " + id + " selected");
    $scope.searchResults.hide = true;
    $scope.searchResults.pos = ((function() {
      var i, len, ref, results;
      ref = $scope.poses;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        pos = ref[i];
        if (pos.id === id) {
          results.push(pos);
        }
      }
      return results;
    })())[0];
    $scope.map.setView([$scope.searchResults.pos.latitude, $scope.searchResults.pos.longitude], 15);
    return $scope.searchResults.pos.marker.openPopup();
  };
  $scope.map.setView([41.997346199999996, 21.4279956], 15);
  redIcon = new L.Icon({
    iconUrl: 'img/red-marker-icon.png'
  });
  greenIcon = new L.Icon({
    iconUrl: 'img/green-marker-icon.png'
  });
  el = angular.element(document.querySelector('#search-map-id'));
  offset = $ionicPosition.offset(el);
  console.log('search-map-id offset (top, left): ', offset.top, offset.left);
  console.log("WxH: " + window.innerWidth + "x" + window.innerHeight);
  el[0].style.height = window.innerHeight - offset.top + 'px';
  $scope.map.on('click', function(e) {
    alert("Покажа на позиција " + e.latlng);
    return $cordovaVibration.vibrate(250);
  });
  angular.element($window).bind('resize', function() {
    console.log('Window size changed: ', $window.innerWidth + "x" + $window.innerHeight);
    return document.getElementById("search-map-id").style.height = $window.innerHeight - offset.top + 'px';
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
    }).addTo($scope.map).bindPopup("Ова е твојата тековна позиција:<br />\n<strong>" + ($scope.position.coords.latitude.toFixed(6)) + ",\n" + ($scope.position.coords.longitude.toFixed(6)) + "</strong>");
  });
  return $scope.$watch('poses', function(n, o) {
    var i, len, marker, pos, ref, results;
    if (n == null) {
      return;
    }
    console.log("We have " + $scope.poses.length + " poses to add");
    ref = $scope.poses;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      pos = ref[i];
      marker = L.marker([pos.latitude, pos.longitude], {
        icon: greenIcon
      }).addTo($scope.map).bindPopup("<strong>" + pos.name + "</strong> (" + pos.id + ")<br />\n<hr />\n<address>\n  " + pos.address + " <br />\n  " + pos.city + " <br />\n  тел.: " + pos.telephone + " <br />\n</address>");
      results.push(pos.marker = marker);
    }
    return results;
  });
});
