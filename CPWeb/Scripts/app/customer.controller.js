(function () {
    'use strict';

    angular
        .module('creditPlusApp')
        .controller('customerController', customerController);

    customerController.$inject = ['$location','$scope','customerService'];

    function customerController($location, $scope, customerService) {

        $scope.Customer = new Object();

        $scope.Customer.id = '';
        $scope.Customer.customerNumber = '';
        $scope.Customer.customerName = '';

        var id = parseQueryString('CustomerId');

        customerService.getCustomer(id).
            then(function (data) {
                $scope.Customer = data; 
            });
    }

    function parseQueryString(key)
    {
        // Build an empty URL structure in which we will store
        // the individual query values by key.
        var objURL = new Object();
        // Use the String::replace method to iterate over each
        // name-value pair in the query string. Location.search
        // gives us the query string (if it exists).
        window.location.search.replace(
            new RegExp("([^?=&]+)(=([^&]*))?", "g"),
        // For each matched query string pair, add that
        // pair to the URL struct using the pre-equals
        // value as the key.
        function ($0, $1, $2, $3) {
            objURL[$1] = $3;
        }
        );


        return objURL[key];
    }

})();
