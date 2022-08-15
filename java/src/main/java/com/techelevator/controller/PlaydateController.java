package com.techelevator.controller;


import com.techelevator.dao.PetDao;
import com.techelevator.dao.PlaydateDao;
import com.techelevator.dao.UserDao;
import com.techelevator.model.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.security.Principal;
import java.util.List;

@CrossOrigin(origins = "http://localhost:8080")
@RestController
public class PlaydateController {
    private PlaydateDao playdateDao;
    private UserDao userDao;
    private PetDao petDao;

    public PlaydateController(PlaydateDao playdateDao, UserDao userDao, PetDao petDao) {
        this.playdateDao = playdateDao;
        this.petDao = petDao;
        this.userDao = userDao;
    }

    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path = "/playdate", method = RequestMethod.POST)
    public void createPlaydate(Principal principal, @Valid @RequestBody Playdate newPlaydate) {
        String userName = principal.getName();
        User currentUser = userDao.findByUsername(userName);
        try {
            playdateDao.create(currentUser.getId(), newPlaydate.getZipCode(), newPlaydate.getDateTime(), newPlaydate.getDetails(), newPlaydate.getRating(), newPlaydate.getStatus(), newPlaydate.getPlaydatePhoto(), newPlaydate.getPetId());
        } catch (PlaydateAlreadyExistsException e) {
        }
    }

    @CrossOrigin
    @PreAuthorize("isAuthenticated()")
    @RequestMapping(path = "/playdate/{playdateId}", method = RequestMethod.PUT)
    public Playdate updatePlaydate(@PathVariable int playdateId, @RequestBody Playdate playdate) throws PlaydateNotFoundException {
        playdate.setPlaydateId(playdateId);
        return playdateDao.updatePlaydate(playdate);
    }

    @RequestMapping(path = "/playdate/{playdate_id}", method = RequestMethod.GET)
    public Playdate getPlaydateById(@PathVariable int playdate_id) {
        Playdate newPlaydate = new Playdate();
        try {
            newPlaydate = playdateDao.getPlaydateById(playdate_id);
        } catch (PlaydateNotFoundException e) {

        }
        return newPlaydate;
    }

    @RequestMapping(path = "/playdate", method = RequestMethod.GET)
    public List<Playdate> playdateList() {
        return playdateDao.listAllPlaydates();
    }



}
