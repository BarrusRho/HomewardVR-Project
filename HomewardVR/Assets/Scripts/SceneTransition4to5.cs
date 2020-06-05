using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneTransition4to5 : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "EventTrigger")
        {
            SceneManager.LoadScene("Level_Five");
        }
    }
}
