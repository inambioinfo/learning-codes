app.controller("myCtrl",["$scope","$http",function($scope, $http){
    console.log("myApp works")
    $scope.firstName = "C.J.";
    $scope.lastName = "Liu";
    $scope.fullName = function(){
        return $scope.firstName + " " + $scope.lastName;
    };
}]);

app.controller("repeatCtrl", ["$scope","$http",function($scope, $http){
    console.log("repeat Application works!");
    var names=[
        {name:'C.J.', country:'China'},
        {name:'cj', country:'USA'},
        {name:'Kelly', country:'China'}];
    $scope.names = names;
}]);

app.controller("myCtrl-1",["$scope","$http",function($scope,$http){
    $scope.name = "KELLY";
    console.log("run myCtrl-1 app");
}]);

// app.controller("",["$scope","$http",function($scope,$http){
    // console.log("run  app");
// }]);
app.controller("myCtrl-2",["$scope","$http",function($scope,$http){
    console.log("run myCtrl-2 app");
    $scope.firstName = "C.J.";
    $scope.changeName = function(){
        $scope.firstName = "Kelly";
    };
}]);

app.controller("namesCtrl",["$scope","$http",function($scope,$http){
    console.log("run namesCtrl app");
    $scope.names = [
        'Jani',
        'Carl',
        'Margareth',
        'Hege',
        'Joe',
        'Gustav',
        'Birgit',
        'Mary',
        'Kai'
    ];
}])

app.controller("namesCtrl-table",["$scope","$http",function($scope,$http){
    console.log("run namesCtrl-table app");
    $scope.names = [
        {name:'Jani',country:'Norway', age:10},
        {name:'Carl',country:'Sweden',age:3},
        {name:'Margareth',country:'England', age:15},
        {name:'Hege',country:'Norway', age:100},
        {name:'Joe',country:'Denmark', age:23},
        {name:'Gustav',country:'Sweden', age:20},
        {name:'Birgit',country:'Denmark', age:400},
        {name:'Mary',country:'England', age:10},
        {name:'Kai',country:'Norway', age:30}
    ];
    
    $scope.orderByMe = function(x) {
        $scope.myOrderBy = x;
    }
}])

app.controller("locationCtrl",["$scope","$http","$location",function($scope,$http,$location){
    console.log("run locationCtrl app");
    $scope.myURL = $location.absUrl();
}])

app.controller("intervalCtrl",["$scope","$http","$interval",function($scope,$http,$interval){
    console.log("run  intervalCtrl app");
    $scope.theTime = new Date().toLocaleTimeString();
    $interval(function(){$scope.theTime = new Date().toLocaleTimeString()},1000);
}]);

app.controller("timeoutCtrl",["$scope","$http", "$timeout",function($scope,$http, $timeout){
    console.log("run timeoutCtrl app");
    $scope.myHeader = "Hello World!!!";
    $timeout(function(){$scope.myHeader="Hello C.J.";},2000);
}]);


app.controller("httpCtrl",["$scope","$http",function($scope,$http){
    console.log("run httpCtrl app");
    $http.get("http://www.w3schools.com/angular/customers.php").then(function(response) {
    $scope.content = response.data;
    $scope.statuscode = response.status;
    $scope.statustext = response.statusText;
    $scope.headers = response.headers();
    $scope.config = response.config;
    
    $scope.myData = response.data.records;
    });
}]);

app.controller("dropDown",["$scope","$http",function($scope,$http){
    console.log("run dropDown app");
    $scope.names = ["Emil", "Tobias", "Linus"];
}]);

app.controller("radioCtrl",["$scope","$http",function($scope,$http){
    console.log("run radioCtrl app");
}]);

app.controller("checkboxCtrl",["$scope","$http",function($scope,$http){
    console.log("run checkboxCtrl app");
}]);










