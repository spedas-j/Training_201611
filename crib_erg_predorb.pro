; 
; CRIBSHEET FOR LOADING AND PLOTTING ERG PREDICTED ORBIT. 
; 
; AUTHOR: 
;    Kunihiro Keika, Univ. Tokyo (Nov., 2016) 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
;= = = = LOAD ERG PREDICTED ORBIT DATA = = = = 
; 
; TIME SETTING 
timespan, '2017-11-15', 2 
;
; LOAD ERG PREDICTED ORBIT 
print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' 
print, '!!! Loading ERG predicted orbit...' 
print, '!!! User name and Password are available on site.' 
print, '!!! Type the following command:' 
print, '!!!    erg_load_orb, /pre, uname=Username (in character), passwd=Password (in character)' 
print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' 
goto, erg1
   erg_load_orb, /pre, uname='********', passwd='********'
erg1: 
stop 
;
; CHECK TPLOT VARIABLES 
tplot_names, '*' 
;
; CHECK WHAT DATA ARE STORED IN TPLOR VARIABLE #3. 
get_data, 'erg_orb_pre_l2_pos_sm', data=data, dlim=dlim 
stop
help, dlim, /st 
stop
help, dlim.cdf, /st 
stop
help, dlim.cdf.gatt, /st 
stop
help, dlim.cdf.vatt, /st 
stop


; = = = = ERG predicted orbit using "tplotxy" command = = = = 
;Create an empty window and change the character size  
thm_init
window, 0, xsize=800, ysize=640 & erase
!p.charsize=1.5

; Change the time range. 
timespan, ['2017-11-15/20:00:00','2017-11-16/05:00:00'] 

;ERG predicted orbit on the SM X-Y plane
tplotxy, 'erg_orb_pre_l2_pos_sm', xrange=[-8,8], yrange=[-8,8] 
stop 

;ERG predicted orbit on the SM X-Z plane
tplotxy, 'erg_orb_pre_l2_pos_sm' , versus='xz', xrange=[-8,8], yrange=[-8,8] 
stop 


; = = = = Time series of ERG positions and model B field = = = = 
;Plot 
tplot, [3,5,8,9], title='ERG positions & Model B field'  
stop 


; = = = = IONOSPHERIC FOOTPRINTS OF ERG = = = = 
; = = = = MAP2D COMMANDS TO DRAW LAT-LON GRID MAP = = = = 
;Preparation for the 2-D plot on the world map 

;Initialize the map2d environment 
!path = !path + ':map2d/' 
map2d_init

;Set the coordinate system to geographical coordinates IDL> map2d_coord, 'geo'

;Generate an empty window 
window, 0, xsize=800, ysize=640 & erase

;Draw the latitude-longitude grid (every 10 deg in lat and 15 deg in lon) on the window. 
;Make the map centered at geographic latitude & longitude of 70. and 270. deg. 
map2d_set, glatc=70., glonc=270. 

;Draw the coast lines of the world map
overlay_map_coast 
stop 


; = = = = OVERLAY_MAP_SC_IFOOT COMMAND TO DRA FOOTPRINTS = = = = 
;Draw the trace of ionospheric footprint for ERG, superposed by the world map.  
split_vec, 'erg_orb_pre_l2_pos_iono_north' 
overlay_map_sc_ifoot, 'erg_orb_pre_l2_pos_iono_north_0', 'erg_orb_pre_l2_pos_iono_north_1'
stop 

;---OPTION FOR A SPECIFIC TIME RANGE--- 
;map2d_set, /erase
;overlay_map_coast
;overlay_map_sc_ifoot, 'erg_orb_pre_l2_pos_iono_north_0', 'erg_orb_pre_l2_pos_iono_north_1’, $
; ['2017-11-15/20:00','2017-11-16/01:00'] 


end 
