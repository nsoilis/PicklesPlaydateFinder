<template>
  <div>
<h1>Welcome to {{ $store.state.user.firstName }}'s Profile.</h1>
    <div class="header">
    

    <h2>Your Pets:</h2>
   
    </div>
    
    <div class="petList">

    
    <div
      v-for="p in $store.state.currentUserPetArray"
      v-bind:key="p.petId"
      class="user-pets"
    >
      <router-link class="router-link-pets" :to="{name: 'pet-info', params: {petId: p.petId}}">{{p.name}}</router-link>
      <div class="right-panel"></div>
    </div>
</div>
    
    <div class="main-container">

    <h2 v-if="playdateArray.length > 0">Playdates you're hosting:</h2>
    <div
      v-for="playdate in playdateArray"
      v-bind:key="playdate.playdateId"
      class="user-playdates"
    >
      <div class="playdateImage">
        <img
          :src="playdate.playdatePhoto"
          alt="playdate photo"
          class="pet-img"
        />
        <p>Details: <br />{{ playdate.details }}</p>
      </div>
      
      <div class="hosting-info">
      
      <p class="hosting-p">Time: <br />{{ changeDateTime(playdate.dateTime) }}</p>
      <!-- <p>Pets: {{ petNames }}</p> -->
      <p class="hosting-p">Pets: <br /> <ul class="hosting-p"><li v-for="pet in playdatePetArray" v-bind:key="pet.id"> 
        <router-link class="router-link" :to="{name: 'pet-info', params: {petId: pet.petId}}"> {{ pet.name }} the {{pet.species}}</router-link>
         </li>
      </ul> </p>
      <p class="hosting-p">Status: <br />{{ playdate.status }}</p>
      <div class="delete-container">
      <button class='btn delete-btn' @click="deletePlaydate(playdate.playdateId)" v-if="$store.state.user.id === playdate.hostUserId">Delete Playdate</button>
      </div>
      <div v-if="playdate.status === 'Pending'">
        <p> {{getVisitingUserInfo(playdate.playdateId)[0].visitingUserName}} would like to come to your playdate! View their pets here: </p>
        <p v-for="visitingPet in getVisitingUserInfo(playdate.playdateId)" v-bind:key="visitingPet.petId"><router-link :to="{path: '/pet/'+visitingPet.petId}">{{visitingPet.petName}}</router-link></p>
        <button class='btn' @click="acceptInvite(playdate)">Accept</button>
        <button class='btn' @click="rejectInvite(playdate)">Reject</button>      
      </div>
      </div>
      <div></div>
    </div>
    
    <h2 v-if="visitingPlaydateArray.length > 0">Playdates you've Requested:</h2>
    <div
      v-for="playdate in visitingPlaydateArray"
      v-bind:key="playdate.playdateId"
      class="user-playdates"
    >
      <div class="petImage">
        <img
          :src="playdate.playdatePhoto"
          alt="playdate photo"
          class="pet-img"
        />
      </div>

      <div class="hosting-info">
        <p>Host: <br />{{ playdate.hostUsername }}</p>
      <p>Details: <br />{{ playdate.details }}</p>
      <p>Time: <br />{{ changeDateTime(playdate.dateTime) }}</p>
       <p>Pets: <br /> <ul><li v-for="pet in visitingPlaydatePetArray" v-bind:key="pet.id"> 
         <router-link class="router-link" :to="{name: 'pet-info', params: {petId: pet.petId}}"> {{ pet.name }} the {{pet.species}}</router-link>
         </li>
      </ul> </p>
      <p>Status: <br />{{ playdate.status }}</p>
      
      </div>
       <div></div>
       </div>  
    </div>

    <!-- <button @click="test">Test</button> -->
  </div>
</template>

<script>
//import userService from '@/services/userService.js';
import petService from "@/services/petService.js";
import playdateService from "@/services/playdateService.js";
import moment from "moment";
import userService from "@/services/userService.js";
// import PetDetails from '@/components/PetDetails.vue';

export default {
  name: "profile-component",
  components: {
    // PetDetails
  },
  data() {
    return {
      isEditing: false, 
      // user: {},
      pets: [],
      petNames: [],
      playdateArray: [],
      playdatePetArray: [],
      visitingPlaydateArray: [],
      visitingPlaydatePetArray: [],
      visitingUserPets: [],
      value: [],
      options: [
        {
          id: 1,
          personality: "Timid",
        },

        {
          id: 2,
          personality: "Tires Quickly",
        },

        {
          id: 3,
          personality: "Independent",
        },

        {
          id: 4,
          personality: "Playful",
        },

        {
          id: 5,
          personality: "Toy Sharing",
        },

        {
          id: 6,
          personality: "Confident",
        },

        {
          id: 7,
          personality: "High Energy",
        },

        {
          id: 8,
          personality: "Toy Possessive",
        },
      ],
    };
  },

  computed: {} ,

  methods: {
    getVisitingUserInfo(id) {
      var allPets = []
      for (var vup of this.visitingUserPets) {
        if (id===vup.playdateId) {
          allPets.push(vup);
        }
        return allPets
      }
    },
    changeDateTime(dateTime) {
      let dateTimeFormat = moment(dateTime).format("MMMM Do YYYY, h:mm a");
      return dateTimeFormat;
    },
    getAge(birthDate) {
      let today = new Date();
      let birthday = new Date(birthDate);
      let age = today.getFullYear() - birthday.getFullYear();
      let month = today.getMonth() - birthday.getMonth();
      if (month < 0 || (month === 0 && today.getDate() < birthday.getDate())) {
        age--;
      }
      return age;
    },
    savePet(pet) {
      pet.personality = [];
      for (let i of this.value) {
        pet.personality.push(i.id);
      }
      this.isEditing = false;
      petService.updatePet(pet, pet.petId).then((response) => {
        if (response.status === 200 || response.status === 204) {
          console.log(response);
          petService
            .getPetsByUserId(this.$store.state.user.id)
            .then((response) => {
              if (response.status === 200) {
                this.$store.commit("ADD_PETS_TO_USER", response.data);
              }
            });
        }
      });
    },
    sizeToString(sizeNum) {
      let size = "";
      switch (sizeNum) {
        case 1:
          size = "Up to 15 pounds";
          return size;
        case 2:
          size = "15 - 30 pounds";
          return size;
        case 3:
          size = "30 - 50 pounds";
          return size;
        case 4:
          size = "50 - 90 pounds";
          return size;
        case 5:
          size = "Bigger than 90 pounds";
          return size;
      }
      return size;
    },
    personalityToString(personalityArr) {
      let personalityString = "";

      personalityArr.forEach((personalityId) => {
        if (personalityId === 1) {
          personalityString += "| Timid |";
        } else if (personalityId === 2) {
          personalityString += "| Tires Quickly |";
        } else if (personalityId === 3) {
          personalityString += "| Independent |";
        } else if (personalityId === 4) {
          personalityString += "| Playful |";
        } else if (personalityId === 5) {
          personalityString += "| Toy Sharing |";
        } else if (personalityId === 6) {
          personalityString += "| Confident |";
        } else if (personalityId === 7) {
          personalityString += "| High Energy |";
        } else if (personalityId === 8) {
          personalityString += "| Toy Possessive |";
        }
      });

      return personalityString;
    },
    acceptInvite(playdate) {
      playdate.status = "Accepted";
      playdateService
        .updatePlaydate(playdate.playdateId, playdate)
        .then((response) => {
          if (response.status === 200 || response.status === 204) {
            console.log(response);
          }
        });
    },
    rejectInvite(playdate) {
      playdate.status = "Rejected";
      playdateService
        .updatePlaydate(playdate.playdateId, playdate)
        .then((response) => {
          if (response.status === 200 || response.status === 204) {
            console.log(response);
          }

          var newPlaydate = playdate;
          newPlaydate.status = "Posted";
          newPlaydate.visitingUserId = null;
          playdateService.createPlaydate(newPlaydate).then((response) => {
            if (response.status === 200) {
              this.$store.commit("ADD_PLAYDATE_TO_ARRAY", newPlaydate);
            }
          });
        });
    },
    getNamesFromId(id) {
      this.$store.state.petArray.find((element) => {
        element.id === id;
      });
    },
    deletePlaydate(playdateId) {
      playdateService.deletePlaydate(playdateId).then((response) => {
        if (response === 200) {
          playdateService.getAllPlaydates().then((response) => {
            if (response === 200) {
              this.$store.commit("ADD_ALL_PLAYDATE", response.data);
            }
          });
        }
        this.$router.go();
      });
    },
  },

  created() {
    playdateService.getAllPlaydates().then((response) => {
      if (response.status === 200) {
        this.$store.commit("ADD_ALL_PLAYDATE", response.data);
        this.playdateArray = this.$store.state.playdateArray.filter(
          (playdate) => playdate.hostUserId === this.$store.state.user.id
        );
        this.visitingPlaydateArray = this.$store.state.playdateArray.filter(
          (playdate) => playdate.visitingUserId === this.$store.state.user.id
        );
      }
      for (var playdate of this.playdateArray) {
        petService.getPetsByPlaydateId(playdate.playdateId).then((response) => {
          if (response.status === 200) {
            this.playdatePetArray = response.data;
            if (playdate.visitingUserId > 0) {
              userService.getById(playdate.visitingUserId) 
              .then( (response) =>{
                if (response.status === 200) {
                  var visitingUser = response.data;
                  console.log(visitingUser);
                  petService.getPetsByUserId(visitingUser.id)
                  .then((response) =>{
                    if (response.status === 200) {
                      var visitingPets = response.data;
                      console.log(visitingPets);
                      for (var pet of visitingPets) {
                        this.visitingUserPets.push({
                          playdateId: playdate.playdateId,
                          visitingUserName: visitingUser.username,
                          petId: pet.petId,
                          petName: pet.name
                        });
                      }
                    }
                  });
                }
              });
            }
          }
        });
      }
      for (var visitingPlaydate of this.visitingPlaydateArray) {
        petService
          .getPetsByPlaydateId(visitingPlaydate.playdateId)
          .then((response) => {
            if (response.status === 200) {
              this.visitingPlaydatePetArray = response.data;
            }
          })
          .catch((error) => {
            console.log(error);
          });
      }

      petService.getPetsByUserId(this.$store.state.user.id).then((response) => {
        if (response.status === 200) {
          this.pets = response.data;
          this.$store.commit("ADD_PETS_TO_USER", response.data);
        }
      
      });
      //   const unique = (value, index, self) => {
      //   return self.indexOf(value) === index;
      // };
      //     let allPetsArray = this.$store.state.petArray;
      //     let playdatePets = this.playdate.petId; //this.playdate does not exist

      //     for(let i=0; i<allPetsArray.length; i++) {

      //         playdatePets.forEach((element) => {

      //             allPetsArray.forEach(pet => {
      //                 let petIdHere = pet.petId;

      //                 if (element === petIdHere)
      //                 this.petNames.push("does this work")

      //                  })
      //             })
      //         this.petNames(unique);
      //     }
      //   }
      //I think the below is extra
      // petService.getPetsByUserId(this.$store.state.user.id).then((response) => {
      //   if (response.status === 200) {
      //     this.pets = response.data;
      //     this.$store.commit("ADD_PETS_TO_USER", response.data);
      //     this.playdateArray = this.$store.state.playdateArray.filter(
      //       (playdate) => playdate.hostUserId === this.$store.state.user.id
      //     );
      //     this.visitingPlaydateArray = this.$store.state.playdateArray.filter(
      //       (playdate) => playdate.visitingUserId === this.$store.state.user.id
      //     );
      //   }
      // });
      //  });
    });
  },

  mounted() {},

  //need:
  // - this user's playdates
  //to make this editable
};
</script>

<style scoped>
.hosting-p {
  margin-bottom: 0;
}

.main-container {
  display: flex;
  flex-direction: column;
}

li > .router-link {
  color: blue;
  font-weight: bold;
}

.delete-container {
  display: flex;
  justify-content: center;
}

.delete-btn {
  
}

img.pet-img {
  margin: 1rem 1rem 1rem 1rem;
}

.btn[data-v-bf1681ae] {
  width: 11rem;
}

ul {
padding: 0px;
margin-top: 0px;
}

.petList{
  display: flex;
  flex-direction: column;
  align-items: center;
}
.petImage {
  width: 1%;
}
.user-pets {
  background-color: #52b69a;
  display: flex;
  border-radius: 10px;
  margin-top: 1rem;
  justify-content: center;
  width: 33%;
  padding: 10px;
}

input,
select {
  margin: 0;
  line-height: 1rem;
  display: inline-block;
  padding: 0;
  text-align: left;
  border-radius: 5px;
  width: 50%;
}

.name {
  margin-top: 0.75rem;
}

.right-panel {
}

.pet-item {
  padding: 0;
}

.pet-img {
  display: block;
  max-width: 25rem;
  max-height: 15rem;

  border-radius: 10px;
}

.playdate-img {
  display: block;
  width: 25rem;
  height: 100%;
  border-radius: 10px;
}

.pet-info {
  display: flex;
  flex-direction: column;
  width: 40%;
  justify-content: center;
}

button {
  border-radius: 5px;
  width: 50%;
}

li {
  list-style: none;
}

.user-playdates {
  background-color: #d9ed92;
  display: flex;
  border-radius: 10px;
  margin-top: 1rem;
  justify-content: space-between;
  flex-direction: row;
  width: 50%;
  align-self: center;
}

.hosting-info {
  display: flex;
  flex-direction: column;
  width: 40%;
  justify-content: center;
}

h1 {
  margin-top: 0;
}

.view {
  border-color: transparent;
  background-color: initial;
  color: initial;
  font-family: "Cabin", sans-serif;
  font-size: initial;
}

span {
  font-weight: normal;
}

.edit-btn {
  width: 5rem;
  height: 2rem;
  font-family: "Cabin", sans-serif;
  background-color: var(--btn-green);
  font-weight: bold;
  font-size: 1rem;
  align-self: flex-end;
}

.header {
  display: flex;
  justify-content: space-between;
}

h1,
h2 {
  margin: 0;
  padding: 0;
  align-self: flex-end;
}

h1 {
  text-align: center;
}

h2 {
  flex-grow: 1;
  margin-top: 1rem;
  align-self: center;
}

.btn {
  width: 10rem;
  height: 3rem;
  line-height: initial;
  color: black;
  font-weight: bold;
  font-size: 1rem;
}

.edit-btn:hover {
  box-shadow: 0 10px 10px rgba(0, 0, 0, 0.18);
}

.playdateImage {
  display: flex;
  
}

.petImage[data-v-bf1681ae] {
  width: 40%;
}

.router-link-pets {
  text-decoration: none;
  color: white;
}

.router-link {
    text-decoration: none;
    color: var(--primary-green);
}

</style>

