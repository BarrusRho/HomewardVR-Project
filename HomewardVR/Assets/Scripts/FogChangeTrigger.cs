using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FogChangeTrigger : MonoBehaviour
{
    [SerializeField]
    private GameObject _fogChange;     

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "EventTrigger")
        {
            _fogChange.SetActive(true);
        }

        if (other.tag == "Player")
        {
            Destroy(this.gameObject, 0f);
        }
    }
}
