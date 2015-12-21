import Router
import Middleware

let router = Router { route in
  route.router("/api", APIv1 >>> log)
}
