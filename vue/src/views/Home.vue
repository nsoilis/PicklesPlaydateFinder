<template>
<div class="root">
  <div class="home">
    
      <div class="playdate-panel">
          <div class="playdate-list"> 
          <play></play>
        </div>
        <div class="map-panel">
            <add-google-map></add-google-map>
        </div>
        <div>
          
        </div>
       
      </div>
    <div class="login-panel" v-if="$store.state.token == ''">
    <login></login>
    </div>
</div>
    <div>
    <app-intro></app-intro>
    </div>
    <div class="pet-spotlight">
      <pet-spotlight></pet-spotlight>
      </div>


  </div>
</template>

<script>
import Login from '@/components/Login.vue';
import PetSpotlight from '@/components/PetSpotlight.vue';
import AppIntro from '@/components/AppIntro.vue';
import play from '../components/PlayDate.vue';
import AddGoogleMap from '@/components/AddGoogleMap.vue';

export default {
  name: "home",
  components: {
    Login,
    PetSpotlight,
    AppIntro,
    play,
    AddGoogleMap,
  

  }
};
</script>

<style scoped>
.map-panel {
  overflow: hidden;
  width: 50%;
}
.map-panel[data-v-fae5bece] {
    width: 50%;
    display: flex;
    flex-shrink: 5;
    flex-direction: column;
    flex-wrap: nowrap;
    align-content: stretch;
    justify-content: flex-end;
    align-items: stretch;
}

div.vue-map {
  opacity: 10%;
}
.home {
  display: flex;
  justify-content: space-around;
}
.login-panel,.playdate-panel{
  /* flex-grow: 1 */
  flex-basis: 33%;
  justify-content: space-between;
  
}
.login-panel {
  background-color: var(--primary-green);
  border-radius: 15px 15px 15px 15px;
  flex-grow: 1;
  margin: 0 1rem 0 1rem;
  box-shadow: 0px 5px 5px rgba(0, 0, 0, 0.18);
  height: 40vh;
  transition: box-shadow 10ms;
}

.login-panel:hover,
.playdate-panel:hover {
  box-shadow: 0px 10px 10px rgba(0, 0, 0, 0.18);
  
}

.playdate-panel{
  display: flex;
  background-color: var(--secondary-green);
  flex-grow: 90;
  margin: 0 1rem 0 1rem;
  border-radius: 15px 15px 15px 15px;
  box-shadow: 0px 5px 5px rgba(0, 0, 0, 0.18);
  height: 40vh;
  
}
.playdate-map{
  height: 10%;
  width: 10%;
}

.playdate-list{
  display: flex;
  height: 40vh;
  flex-wrap: wrap;
}

body {
  padding-top: 1rem;
}


</style>
