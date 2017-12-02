-- firework mod by Plebs, oct 2017

local textures={"firework_white.png","firework_green.png","firework_pink.png","firework_cyan.png","firework_red.png","firework_blue.png","firework_yellow.png","firework_white.png"}
local originsphere={}					-- calc vectors only once and store in array to save time

local time_countdown=3.0;			-- particle trajectories are calculated just-in-time
local speed_motor=6.4;				-- so all these variables can be adjusted for diffrent needs
local time_flight=3.2;				-- the values were adjusted to look like real fireworks on low end hardware
local speed_explosion=3.6;
local time_explosion=0.6;
local acc_gravity=-0.8;
local acc_airdrag=-2.4;

local function generate_sphere(rings,sectors)
	local bla={1,4,8,12,8,4,1}		-- bc i'm too stupid to make a dynamic sphere gen
	local i=1;local ring;local sector;local s_gap
	local r_gap=(1/(rings))			-- spacings
	
	for ring=0,rings do
		for sector=0,bla[ring+1]-1 do			
			s_gap=(1/(bla[ring+1]))			
			originsphere[i]={}
			originsphere[i].x=math.cos(2*math.pi*sector*s_gap) * math.sin(math.pi*ring*r_gap);
			originsphere[i].y=math.sin(-(math.pi/2) + math.pi*ring*r_gap);
			originsphere[i].z=math.sin(2*math.pi*sector*s_gap) * math.sin(math.pi*ring*r_gap);
			i=i+1
		end
	end	
end


generate_sphere(6,12)	-- precalculate sphere only once on start (param: rings, sectors)
minetest.log("firework mod with " .. #textures .." textures loaded. " .. #originsphere .." vectors have been precalculated successfully")


minetest.register_craftitem("firework:rocket",{		-- firework code and images by Plebs, Oct 2017
	description = "Firework Rocket",														-- uses only built-in sounds
	inventory_image = "firework_rocket.png",
		
	on_use = function(itemstack, player, pointed_thing)	
		local mypos = minetest.get_pointed_thing_position(pointed_thing,true)	-- get placing position			
		if mypos == nil then return end							-- if no solid ground clicked, return
		mypos.vx=0;mypos.vy=0;mypos.vz=0;						-- needs to be set, could be called in callback, before its generated due lag
		local sphere={};
		local i;
		local randomtexture=math.random(0,3)											-- create a random texture for this firework
		local acc_drift_x=(math.random()-0.5)										-- random flight drift
		local acc_drift_z=(math.random()-0.5)
		for i=1,#originsphere do sphere[i]={};sphere[i].x=originsphere[i].x;sphere[i].y=originsphere[i].y;sphere[i].z=originsphere[i].z;sphere[i].vx=0;sphere[i].vy=0;sphere[i].vz=0;end		-- make a copy of precalculated sphere
		mypos.y=mypos.y-0.25;																	-- rocket offset, so halfsized texture touches the ground

		minetest.add_particle({																			-- place rocket
			pos={x=mypos.x,y=mypos.y,z=mypos.z},
			velocity={x=0,y=0,z=0},
			acceleration={x=0,y=0,z=0},
			expirationtime=time_countdown,size=5,collisiondetection=false,vertical=false,glow=LIGHT_MAX*0.8,
			texture="firework_rocket.png",minetest.sound_play("default_place_node",{pos=mypos,max_hear_distance=8})})

		minetest.after(time_countdown,function()			
			minetest.add_particle({																		-- smoke
				pos={x=mypos.x,y=mypos.y-0.15,z=mypos.z},
				velocity={x=0,y=-0.04,z=0},
				acceleration={x=0,y=0,z=0},
				expirationtime=2,size=8,collisiondetection=false,vertical=false,glow=2,
				texture="default_item_smoke.png",minetest.sound_play("default_cool_lava",{pos=mypos,max_hear_distance=8,})})				

			minetest.add_particle({																		-- flight rocket
				pos={x=mypos.x,y=mypos.y,z=mypos.z},
				velocity={x=0,y=speed_motor,z=0},
				acceleration={x=acc_drift_x,y=acc_airdrag,z=acc_drift_z},
				expirationtime=time_flight,size=5.0,collisiondetection=false,vertical=false,glow=LIGHT_MAX*0.8,
				texture="firework_rocket.png",minetest.sound_play("default_place_node",{pos=mypos,max_hear_distance=8})})
			mypos.x=mypos.x+ (0.5*acc_drift_x*time_flight*time_flight);		--update particles to predicted new postions
			mypos.y=mypos.y+((0.5*acc_airdrag*time_flight*time_flight)+(speed_motor*time_flight));
			mypos.z=mypos.z+ (0.5*acc_drift_z*time_flight*time_flight);
			mypos.vx=(acc_drift_x*time_flight)*0.5
			mypos.vy=((acc_airdrag*time_flight)+speed_motor)*0.25
			mypos.vz=(acc_drift_z*time_flight)*0.5
			end)

		minetest.after(time_countdown+time_flight,function()					-- show inital explosion			
			for i=1,#sphere do
				sphere[i].vx=(sphere[i].x*speed_explosion);
				sphere[i].vy=(sphere[i].y*speed_explosion);
				sphere[i].vz=(sphere[i].z*speed_explosion);

				minetest.add_particle({
					pos={x=mypos.x,y=mypos.y,z=mypos.z},
					velocity={x=mypos.vx,y=mypos.vy,z=mypos.vz},
					acceleration={x=sphere[i].vx,y=sphere[i].vy,z=sphere[i].vz},
					expirationtime=time_explosion,size=0.5,collisiondetection=false,vertical=false,glow=LIGHT_MAX*0.8,
					texture="firework_yellow.png"})						
				sphere[i].x=mypos.x+(0.5*sphere[i].vx*time_explosion*time_explosion)+(mypos.vx*time_explosion);		--update particles to predicted new postions
				sphere[i].y=mypos.y+(0.5*sphere[i].vy*time_explosion*time_explosion)+(mypos.vy*time_explosion);
				sphere[i].z=mypos.z+(0.5*sphere[i].vz*time_explosion*time_explosion)+(mypos.vz*time_explosion);						
				sphere[i].vx=((sphere[i].vx*(time_explosion))+mypos.vx)*0.125;
				sphere[i].vy=((sphere[i].vy*(time_explosion))+mypos.vy)*0.125;
				sphere[i].vz=((sphere[i].vz*(time_explosion))+mypos.vz)*0.125;
			end;
		end)

		minetest.after(time_countdown+time_flight+time_explosion,function()					-- show spectacular particles
			for i=1,#sphere do
				minetest.add_particle({
					pos={x=sphere[i].x,y=sphere[i].y,z=sphere[i].z},
					velocity={x=sphere[i].vx,y=sphere[i].vy,z=sphere[i].vz},
					acceleration={x=0,y=acc_gravity,z=0},
					expirationtime=(math.random()*0.5)+1.4,size=(math.random()*0.4)+0.6,collisiondetection=false,vertical=false,glow=LIGHT_MAX,
					texture=textures[math.random(1,2)+(randomtexture*2)]})
			end;
		end)
	
	
	minetest.after(time_countdown+time_flight+0.1,function()	-- the sounds are detached, with slight delay for natural feeling
		minetest.sound_play("default_dug_node",{pos={x=mypos.x,y=mypos.y,z=mypos.z},max_hear_distance=12})end)

	minetest.after(time_countdown+time_flight+time_explosion+0.1,function()
		minetest.sound_play("default_dug_node",{pos={x=mypos.x,y=mypos.y,z=mypos.z},max_hear_distance=12})end)

	minetest.after(time_countdown+time_flight+time_explosion+0.2,function()
		minetest.sound_play("default_dug_node",{pos={x=mypos.x,y=mypos.y,z=mypos.z},max_hear_distance=12})end)


	itemstack:take_item()
	return itemstack
	end
})


	-- fountain code and images by Plebs, Oct 2017


minetest.register_craftitem("firework:fountain",{
	description = "Firework Fountain",														-- uses only built-in sounds
	inventory_image = "firework_fountain.png",
		
	on_use=function(itemstack,player,pointed_thing)	
		local mypos=minetest.get_pointed_thing_position(pointed_thing,true)	-- get placing position			
		if mypos==nil then return end							-- if no soild ground clicked, return
		local fountain_textures={"heart.png","bubble.png","firework_star.png"}		

		minetest.add_particle({																			-- place fountain
			pos={x=mypos.x,y=mypos.y-0.25,z=mypos.z},
			velocity={x=0,y=0,z=0},
			acceleration={x=0,y=0,z=0},
			expirationtime=16,size=5,collisiondetection=false,vertical=false,glow=LIGHT_MAX*0.8,
			texture="firework_fountain.png",minetest.sound_play("default_place_node",{pos=mypos,max_hear_distance=8})})

		minetest.after(3,function()
			minetest.add_particlespawner({
				minpos={x=mypos.x,y=mypos.y-0.14,z=mypos.z},maxpos={x=mypos.x,y=mypos.y,z=mypos.z},
				minvel={x=-0.2,y=1.2,z=-0.2},maxvel={x= 0.2,y=2.0,z= 0.2},
				minacc={x=0,y=-0.5,z=0},maxacc={x=0,y=-0.5,z=0},
				amount=64,time=12,minexptime=4,maxexptime=6,minsize=0.5,maxsize=1.0,
				minetest.sound_play("default_cool_lava",{pos=mypos,max_hear_distance=8}),
				collisiondetection=false,vertical=false,glow=LIGHT_MAX,
				texture=fountain_textures[math.random(1,#fountain_textures)]})
		end)

	itemstack:take_item()
	return itemstack
	end})





--    craft receipes

minetest.register_craft{
	type="shapeless",
	output="firework:fountain 25",
	recipe={"dye:blue","dye:yellow","dye:red",
					"default:paper","default:paper","default:paper",
					"default:coal_lump","default:coal_lump","default:coal_lump"}}

minetest.register_craft{
	type="shapeless",
	output="firework:rocket 25",
	recipe={"dye:pink","dye:yellow","dye:cyan",
					"default:paper","default:paper","default:paper",
					"default:coal_lump","default:coal_lump","default:coal_lump"}}










--  snow generator, by Plebs Oct 2017  ..  this is is early alpha for tests and special occasions only
--  not for Players. there can be only one snowarea at a time. amount varies with globalstep settings

local snow=nil;

minetest.register_craftitem("firework:snow",{
	description="Snow",inventory_image="firework_white.png",		
	on_use=function(itemstack,player,pointed_thing)
		snow=player:getpos()
		minetest.after(60,function()snow=nil;end)			-- turn snow off after 60 seconds
		itemstack:take_item()
		return itemstack
	end})

minetest.register_globalstep(function(dtime)			-- snow in area
		if snow==nil then return end									-- if no solid ground clicked, return
		local x=math.random()-0.5;
		local y=math.random();
		local z=math.random()-0.5;
		
		for i=0,3 do	
			minetest.add_particle({
				pos={x=snow.x+((math.random()-0.5)*48),y=snow.y+y+14,z=snow.z+((math.random()-0.5)*48)},
				velocity={x=x*2,y=-(1.0+y),z=z*2},
				acceleration={x=-x*0.6,y=0,z=-z*0.6},
				expirationtime=y+8,size=1,collisiondetection=false,vertical=false,glow=LIGHT_MAX,
				texture="firework_white.png"})
		end
end)
