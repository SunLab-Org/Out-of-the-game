local vector = require "libraries.hump.vector"

Bounce = function (self, b, coll)
        local nx, ny = coll:getNormal()
        print("nx:" .. nx .. "ny:" .. ny)
        local Vx, Vy = self.body:getLinearVelocity()
        

        if nx ~= 0 then Vx = -1 * Vx end
        if ny ~= 0 then Vy = -1 * Vy end

        print("Vx:" .. Vx .. "Vy:" .. Vy)

        local Vvec = vector(Vx, Vy)
        local len = Vvec:len() + 10

        local Pvec = vector(0, 0)

        if b:getUserData().ent then
                local ent = b:getUserData().ent
                local Vxp, Vyp = ent.body:getLinearVelocity()
                Pvec = vector(Vxp, Vyp)
        end

        print("player vec: ", Pvec.x, Pvec.y)

        Vvec = Vvec + Pvec
        local len2 = Vvec:len()

        Vvec = Vvec * len / len2

        print("final vec:", Vx, Vy)

        self.body:setLinearVelocity(Vvec.x, Vvec.y)

        end


