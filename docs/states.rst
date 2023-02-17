Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``wikiless``
^^^^^^^^^^^^
*Meta-state*.

This installs the wikiless, redis containers,
manages their configuration and starts their services.


``wikiless.package``
^^^^^^^^^^^^^^^^^^^^
Installs the wikiless, redis containers only.
This includes creating systemd service units.


``wikiless.config``
^^^^^^^^^^^^^^^^^^^
Manages the configuration of the wikiless, redis containers.
Has a dependency on `wikiless.package`_.


``wikiless.service``
^^^^^^^^^^^^^^^^^^^^
Starts the wikiless, redis container services
and enables them at boot time.
Has a dependency on `wikiless.config`_.


``wikiless.clean``
^^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``wikiless`` meta-state
in reverse order, i.e. stops the wikiless, redis services,
removes their configuration and then removes their containers.


``wikiless.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the wikiless, redis containers
and the corresponding user account and service units.
Has a depency on `wikiless.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``wikiless.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the wikiless, redis containers
and has a dependency on `wikiless.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``wikiless.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the wikiless, redis container services
and disables them at boot time.


