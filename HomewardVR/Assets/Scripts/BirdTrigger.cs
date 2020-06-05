using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BirdTrigger : MonoBehaviour
{
    [SerializeField]
    private GameObject _birdSpawnManager;     

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "EventTrigger")
        {
            _birdSpawnManager.SetActive(true);
        }

        if (other.tag == "Player")
        {
            Destroy(this.gameObject, 0f);
        }
    }
}
