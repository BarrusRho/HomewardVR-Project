using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneTransition5toCredits : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "GreenHeart")
        {
            SceneManager.LoadScene("Level_Credits");
        }
    }
}
