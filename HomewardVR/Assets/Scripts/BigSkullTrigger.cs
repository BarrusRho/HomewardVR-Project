using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BigSkullTrigger : MonoBehaviour
{
    [SerializeField]
    private GameObject _bigSkullSpawnManager;     

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "EventTrigger")
        {
            _bigSkullSpawnManager.SetActive(true);
        }

        if (other.tag == "Player")
        {
            Destroy(this.gameObject, 0f);
        }
    }
}
