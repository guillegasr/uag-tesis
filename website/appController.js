angular.module("MyFirstApp", [])
  .controller("FirstController", ["$scope", "$http", function ($scope, $http) {
    $scope.values = {};
    var apiId= "r94wggpez1";
    $http.get("https://" + apiId + ".execute-api.us-east-1.amazonaws.com/prod/sensors")
      .success(function (data) {
        data = flatten(data)
        console.log(data);
        $scope.values = data.Items;
      })
      .error(function (error) {
        console.log(error);
      });

    function flatten(o) {
      var descriptors = ['L', 'M', 'N', 'S'];

      for (let d of descriptors) {
        if (o.hasOwnProperty(d)) {
          return o[d];
        }
      }

      Object.keys(o).forEach((k) => {

        for (let d of descriptors) {
          if (o[k].hasOwnProperty(d)) {
            o[k] = o[k][d];
          }
        }
        if (Array.isArray(o[k])) {
          o[k] = o[k].map(e => flatten(e))
        } else if (typeof o[k] === 'object') {
          o[k] = flatten(o[k])
        }
      });

      return o;
    }

  }]);