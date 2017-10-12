class GoogleMap {

  constructor(canvas, options) {
    this.markerData = canvas.data("markers") || [];
    this.defaultZoom = canvas.data("zoom");
    this.map;
    this.markers;
    this.boundsCallback = canvas.data("boundsCallback");
    this.dragCallback = canvas.data("dragCallback");
    this.geocoder = new google.maps.Geocoder();
    this.googleMapOptions = {
      styles: [
        {featureType:"administrative",elementType:"labels.text.fill",stylers:[{"color":"#6195a0"}]},
        {featureType:"administrative.province",elementType:"geometry.stroke",stylers:[{"visibility":"off"}]},
        {featureType:"landscape",elementType:"geometry",stylers:[{"lightness":"0"},{"saturation":"0"},{"color":"#f5f5f2"},{"gamma":"1"}]},
        {featureType:"landscape.man_made",elementType:"all",stylers:[{"lightness":"-3"},{"gamma":"1.00"}]},
        {featureType:"landscape.natural.terrain",elementType:"all",stylers:[{"visibility":"off"}]},
        {featureType:"poi",elementType:"all",stylers:[{"visibility":"off"}]},
        {featureType:"poi.park",elementType:"geometry.fill",stylers:[{"color":"#bae5ce"},{"visibility":"on"}]},
        {featureType:"road",elementType:"all",stylers:[{"saturation":-100},{"lightness":45},{"visibility":"simplified"}]},
        {featureType:"road.highway",elementType:"all",stylers:[{"visibility":"simplified"}]},
        {featureType:"road.highway",elementType:"geometry.fill",stylers:[{"color":"#fac9a9"},{"visibility":"simplified"}]},
        {featureType:"road.highway",elementType:"labels.text",stylers:[{"color":"#4e4e4e"}]},
        {featureType:"road.arterial",elementType:"labels.text.fill",stylers:[{"color":"#787878"}]},
        {featureType:"road.arterial",elementType:"labels.icon",stylers:[{"visibility":"off"}]},
        {featureType:"transit",elementType:"all",stylers:[{"visibility":"simplified"}]},
        {featureType:"transit.station.airport",elementType:"labels.icon",stylers:[{"hue":"#0a00ff"},{"saturation":"-77"},{"gamma":"0.57"},{"lightness":"0"}]},
        {featureType:"transit.station.rail",elementType:"labels.text.fill",stylers:[{"color":"#43321e"}]},
        {featureType:"transit.station.rail",elementType:"labels.icon",stylers:[{"hue":"#ff6c00"},{"lightness":"4"},{"gamma":"0.75"},{"saturation":"-68"}]},
        {featureType:"water",elementType:"all",stylers:[{"color":"#eaf6f8"},{"visibility":"on"}]},
        {featureType:"water",elementType:"geometry.fill",stylers:[{"color":"#c7eced"}]},
        {featureType:"water",elementType:"labels.text.fill",stylers:[{"lightness":"-49"},{"saturation":"-53"},{"gamma":"0.79"}]}
      ],
      zoom: 15,
      scrollwheel: false,
      scrollable: false,
      streetViewControl: true,
      zoomControl: true,
      mapTypeControl: true,
      center: new google.maps.LatLng(-33.0, 151.0)
    }
    this.map = new google.maps.Map( canvas[0], this.googleMapOptions);
    this.addMarkers();
    canvas.data("googlemap", this);

    // Map callbacks
    this.addMapCallbacks();
  }

  addMapCallbacks(){
    var _this = this;
    this.map.addListener('bounds_changed', function() {
      _this.boundsChangedCallback();
    });
  }

  addMarkers(){
    var _this = this;
    this.markers = []; // reset markers
    var bounds = new google.maps.LatLngBounds();
    var infoWindow = new google.maps.InfoWindow();
    $.each(this.markerData, function(i, mark){

      if(mark.lat == undefined || mark.lng == undefined){
        return true;
      }
      var markerOptions = {
        position: new google.maps.LatLng(mark.lat, mark.lng)
      }
      var marker = new google.maps.Marker(markerOptions);
      marker.setMap(_this.map);
      if(mark.draggable){
        marker.setDraggable(true);
        google.maps.event.addListener(marker, "dragend", function(event) {
          _this.map.panTo(event.latLng);
          _this.markerDraggedCallback(event.latLng);
        });
      }
      // Add to markers array
      _this.markers.push(marker);
      // Add callback to display marker popover
      if(mark.content_callback != undefined){
        google.maps.event.addListener(marker, 'mouseover', (function(marker) {
          return function() {
            var content = window[mark.content_callback](mark);
            infoWindow.setContent( content );
            infoWindow.open(_this.map, marker);
          }
        })(marker));
      }
      // Update bounds with new marker
      bounds.extend(new google.maps.LatLng(mark.lat, mark.lng));
    })

    if(this.defaultZoom){
      this.map.setCenter(bounds.getCenter());
      this.map.setZoom(this.defaultZoom);
    }else{
      this.map.fitBounds(bounds);
      this.map.setCenter(bounds.getCenter());
    }
  }

  moveMarker(marker, result){
    this.map.setCenter(result.geometry.location);
    this.map.setZoom(18);
    marker.setPosition(result.geometry.location);
    this.markerDraggedCallback( marker.getPosition() );
  }

  markerDraggedCallback(newLatLng){
    if(this.dragCallback){
      window[this.dragCallback](this, newLatLng);
    }
  }

  boundsChangedCallback(){
    if(this.boundsCallback){
      window[this.boundsCallback](this);
    }
  }

}
// Initialize maps on page
function mapInitialize(){
  $('.map-canvas').each(function(){
    new GoogleMap($(this));
  })
}
var googleMapLoadCount = 0;
if(typeof(google) != 'undefined'){
  google.maps.event.addDomListener(window, 'load', mapInitialize);
  google.maps.event.addDomListener(window, 'page:load', mapInitialize);
}

// Google Maps Address Search
function addressMapSearch(address, callback){
  new google.maps.Geocoder().geocode( address, function(results, status) {
    if(status == google.maps.GeocoderStatus.OK){
      window[callback](results);
    }else{
      console.log("Address search error: " + status);
    }
  });
}