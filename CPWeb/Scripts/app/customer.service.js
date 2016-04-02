//(function () {
//    'use strict';

//    var customerService = angular.module('creditPlusApp', ['ngResource']).factory('customerService', ['$resource', '$location',
//        function ($resource, $location) {
//            var url = document.URL;
//            var urlArray = url.split("/");
//            var customerId = urlArray[urlArray.length - 1];

//            return $resource('/api/customers/:id', {}, {

//                get: {
//                    method: 'GET', params: { id: '@id' }, isArray: false
//                }
//            });
//        }
//    ]);

//})();

(function () {

    var injectParams = ['$http', '$q'];

    var customerService = function ($http, $q) {
        var serviceBase = '/api/',
            factory = {};

       

        factory.getCustomer = function (id) {
            //then does not unwrap data so must go through .data property
            //success unwraps data automatically (no need to call .data property)
            return $http.get(serviceBase + 'customers/' + id).then(function (results) {
                return results.data;
            });
        };

        return factory;
    };

    customerService.$inject = injectParams;

    angular.module('creditPlusApp').factory('customerService', customerService);

}());