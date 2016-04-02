using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace CPWeb.api
{
    public class CustomersController : ApiController
    {
        CreditPlusEntities db = new CreditPlusEntities();

        // to Search Student Details and display the result  
        [HttpGet]
        public Customer Get(decimal id)
        {

            var result = db.Rabo_WWW_CustomerDetail(id).FirstOrDefault();

            if (result == null)
            {
                var resp = new HttpResponseMessage(HttpStatusCode.NotFound)
                {
                    Content = new StringContent(string.Format("Customer with ID = {0}", id)),
                    ReasonPhrase = "Customer ID Not Found"
                };

                throw new HttpResponseException(resp);
            }
            return result;
        }
    }
}
