cs=coap.Server()
cs:listen(5683)

function steamnow(payload)
  print("steamnow called, payload: ", payload)
  return 'Got data'
end
cs:func("steamnow")
